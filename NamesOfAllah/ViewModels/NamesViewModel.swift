//
//  NamesViewModel.swift
//  NamesOfAllah
//
//  Main ViewModel for the app
//

import Foundation
import SwiftUI
import Combine

class NamesViewModel: ObservableObject {
    // Data Manager (not @Published since it's already ObservableObject)
    let dataManager = DataManager.shared

    // UI State
    @Published var searchText = ""
    @Published var selectedFilter: NameFilter = .all
    @Published var showOnboarding = false
    @Published var selectedTab: Tab = .home

    // Settings
    @Published var notificationsEnabled = false
    @Published var fontSize: AppConstants.FontSize = .medium
    @Published var isDarkMode = true

    private let defaults = UserDefaults.standard

    enum Tab: String, CaseIterable {
        case home = "اليوم"
        case list = "كل الأسماء"
        case favorites = "المفضلة"
        case settings = "الإعدادات"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .list: return "list.bullet"
            case .favorites: return "heart.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    enum NameFilter: String, CaseIterable {
        case all = "الكل"
        case favorites = "المفضلة"
        case completed = "المكتملة"
    }

    init() {
        checkOnboardingStatus()
        loadSettings()
    }

    // MARK: - Onboarding
    func checkOnboardingStatus() {
        let hasCompleted = defaults.bool(forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding)
        showOnboarding = !hasCompleted
    }

    func completeOnboarding() {
        defaults.set(true, forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding)
        showOnboarding = false
        HapticManager.shared.notification(type: .success)
    }

    // MARK: - Settings
    func loadSettings() {
        notificationsEnabled = defaults.bool(forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)

        if let savedFontSize = defaults.object(forKey: AppConstants.UserDefaultsKeys.fontSize) as? CGFloat,
           let fontSize = AppConstants.FontSize(rawValue: savedFontSize) {
            self.fontSize = fontSize
        }

        isDarkMode = defaults.bool(forKey: AppConstants.UserDefaultsKeys.isDarkMode)
    }

    func saveSettings() {
        defaults.set(notificationsEnabled, forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)
        defaults.set(fontSize.rawValue, forKey: AppConstants.UserDefaultsKeys.fontSize)
        defaults.set(isDarkMode, forKey: AppConstants.UserDefaultsKeys.isDarkMode)
    }

    // MARK: - Filtered Names
    var filteredNames: [Name] {
        var names = dataManager.names

        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .favorites:
            names = dataManager.favoriteNames
        case .completed:
            names = names.filter { dataManager.isCompleted(id: $0.id) }
        }

        // Apply search
        if !searchText.isEmpty {
            names = names.filter { name in
                name.nameArabic.contains(searchText) ||
                name.nameEnglish.localizedCaseInsensitiveContains(searchText) ||
                name.translation.localizedCaseInsensitiveContains(searchText)
            }
        }

        return names
    }

    // MARK: - Name Actions
    func toggleFavorite(id: Int) {
        dataManager.toggleFavorite(id: id)
    }

    func markAsCompleted(id: Int) {
        dataManager.markAsCompleted(id: id)
        HapticManager.shared.notification(type: .success)
    }

    // MARK: - Notifications
    func toggleNotifications() {
        if notificationsEnabled {
            NotificationManager.shared.scheduleDailyNotification()
        } else {
            NotificationManager.shared.cancelNotifications()
        }
        saveSettings()
    }

    // MARK: - Share
    func shareText(for name: Name) -> String {
        return """
        \(name.nameArabic) - \(name.nameEnglish)
        \(name.translation)

        \(name.meaning)

        من تطبيق: أسماء الله الحسنى
        """
    }
}
