//
//  DataManager.swift
//  NamesOfAllah
//
//  Manages data loading and persistence
//

import Foundation
import SwiftUI
import Combine
import Security

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var names: [Name] = []
    @Published var favoriteIDs: Set<Int> = []
    @Published var completedIDs: Set<Int> = []

    // Use App Group to share data with widget
    private let defaults: UserDefaults = {
        let appGroupID = "group.com.alfahad.namesofallah"
        return UserDefaults(suiteName: appGroupID) ?? UserDefaults.standard
    }()

    private init() {
        loadNames()
        loadFavorites()
        loadCompleted()
        migrateStartDateToKeychain()
    }

    // MARK: - Keychain Helpers (persists across app delete/reinstall)
    private func keychainSave(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "com.metin.namesofallah"
        ]
        SecItemDelete(query as CFDictionary)
        var addQuery = query
        addQuery[kSecValueData as String] = data
        SecItemAdd(addQuery as CFDictionary, nil)
    }

    private func keychainLoad(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "com.metin.namesofallah",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Migrate existing appStartDate to Keychain on first run after update
    private func migrateStartDateToKeychain() {
        // If Keychain already has a date, nothing to do
        if keychainLoad(key: "appStartDate") != nil { return }

        // Try to read from UserDefaults (existing users)
        if let savedDate = defaults.object(forKey: "appStartDate") as? Date {
            keychainSave(key: "appStartDate", value: String(savedDate.timeIntervalSince1970))
        }
    }

    // MARK: - Load Names from JSON
    func loadNames() {
        guard let url = Bundle.main.url(forResource: "NamesData", withExtension: "json") else {
            print("❌ Failed to locate NamesData.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            names = try decoder.decode([Name].self, from: data)
            print("✅ Loaded \(names.count) names")
        } catch {
            print("❌ Failed to decode JSON: \(error)")
        }
    }

    // MARK: - Favorites Management
    func loadFavorites() {
        if let favoritesArray = defaults.array(forKey: AppConstants.UserDefaultsKeys.favoriteNames) as? [Int] {
            favoriteIDs = Set(favoritesArray)
        }
    }

    func saveFavorites() {
        defaults.set(Array(favoriteIDs), forKey: AppConstants.UserDefaultsKeys.favoriteNames)
    }

    func toggleFavorite(id: Int) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
            // Haptic feedback
            HapticManager.shared.impact(style: .medium)
        }
        saveFavorites()
    }

    func isFavorite(id: Int) -> Bool {
        return favoriteIDs.contains(id)
    }

    var favoriteNames: [Name] {
        return names.filter { favoriteIDs.contains($0.id) }
    }

    // MARK: - Completed Names Management
    func loadCompleted() {
        if let completedArray = defaults.array(forKey: AppConstants.UserDefaultsKeys.completedNames) as? [Int] {
            completedIDs = Set(completedArray)
        }
    }

    func saveCompleted() {
        defaults.set(Array(completedIDs), forKey: AppConstants.UserDefaultsKeys.completedNames)
    }

    func markAsCompleted(id: Int) {
        completedIDs.insert(id)
        saveCompleted()
    }

    func isCompleted(id: Int) -> Bool {
        return completedIDs.contains(id)
    }

    var completedCount: Int {
        return completedIDs.count
    }

    var progressPercentage: Double {
        guard !names.isEmpty else { return 0 }
        return Double(completedCount) / Double(names.count) * 100
    }

    // MARK: - Name of the Day (Sequential from 1 to 99)
    func getNameOfDay() -> Name? {
        guard !names.isEmpty else { return nil }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Get or set the start date (first day user opens the app)
        // Priority: Keychain > UserDefaults > new date
        let startDateKey = "appStartDate"
        var startDate: Date

        if let keychainDateStr = keychainLoad(key: "appStartDate"),
           let timeInterval = Double(keychainDateStr) {
            startDate = calendar.startOfDay(for: Date(timeIntervalSince1970: timeInterval))
            // Sync back to UserDefaults if missing
            if defaults.object(forKey: startDateKey) == nil {
                defaults.set(startDate, forKey: startDateKey)
            }
        } else if let savedStartDate = defaults.object(forKey: startDateKey) as? Date {
            startDate = calendar.startOfDay(for: savedStartDate)
            // Save to Keychain for future resilience
            keychainSave(key: "appStartDate", value: String(startDate.timeIntervalSince1970))
        } else {
            // First time opening the app - start from today
            startDate = today
            defaults.set(startDate, forKey: startDateKey)
            keychainSave(key: "appStartDate", value: String(startDate.timeIntervalSince1970))
        }

        // Also write to shared container file for widget
        writeStartDateToSharedContainer(startDate)

        // Calculate number of days since start
        let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: today).day ?? 0

        // Calculate which name to show (cycles from 1 to 99)
        let nameIndex = (daysSinceStart % 99)

        return names[safe: nameIndex]
    }

    // Get current day number (1-99)
    func getCurrentDayNumber() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let startDateKey = "appStartDate"
        var startDate: Date?
        if let keychainDateStr = keychainLoad(key: "appStartDate"),
           let timeInterval = Double(keychainDateStr) {
            startDate = Date(timeIntervalSince1970: timeInterval)
        } else if let savedDate = defaults.object(forKey: startDateKey) as? Date {
            startDate = savedDate
        }
        guard let startDate = startDate else {
            return 1 // First day
        }

        let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: today).day ?? 0
        return (daysSinceStart % 99) + 1
    }

    // MARK: - Widget Shared Data
    /// Writes the start date to the App Group shared container as a file
    /// so the widget can read it even if UserDefaults sharing fails
    private func writeStartDateToSharedContainer(_ date: Date) {
        let appGroupID = "group.com.alfahad.namesofallah"
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("⚠️ Could not access App Group container")
            return
        }
        let fileURL = containerURL.appendingPathComponent("appStartDate.txt")
        let timeInterval = String(date.timeIntervalSince1970)
        try? timeInterval.write(to: fileURL, atomically: true, encoding: .utf8)

        // Also write current name index for widget to use directly
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: today).day ?? 0
        let nameIndex = daysSinceStart % 99
        let dayNumber = nameIndex + 1

        let indexFileURL = containerURL.appendingPathComponent("currentNameIndex.txt")
        try? String(nameIndex).write(to: indexFileURL, atomically: true, encoding: .utf8)

        let dayFileURL = containerURL.appendingPathComponent("currentDayNumber.txt")
        try? String(dayNumber).write(to: dayFileURL, atomically: true, encoding: .utf8)
    }

    // MARK: - Search
    func searchNames(query: String) -> [Name] {
        guard !query.isEmpty else { return names }

        return names.filter { name in
            name.nameArabic.contains(query) ||
            name.nameEnglish.localizedCaseInsensitiveContains(query) ||
            name.translation.localizedCaseInsensitiveContains(query)
        }
    }
}


// MARK: - Array Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
