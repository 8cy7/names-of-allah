//
//  NotificationManager.swift
//  NamesOfAllah
//
//  Manages local notifications
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private let defaults = UserDefaults.standard
    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Request Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // MARK: - Schedule Daily Notification
    func scheduleDailyNotification(at hour: Int = 9, minute: Int = 0) {
        // Remove existing notifications first
        center.removeAllPendingNotificationRequests()

        // Schedule notifications for the next 99 days
        let calendar = Calendar.current
        let names = DataManager.shared.names

        guard !names.isEmpty else {
            print("❌ No names available for notification")
            return
        }

        // Get current day number to calculate future days
        let currentDayNumber = DataManager.shared.getCurrentDayNumber()

        // Schedule notification for tomorrow onwards (up to 99 days)
        for dayOffset in 1...99 {
            // Calculate which name to show for this future day
            let futureDayNumber = ((currentDayNumber + dayOffset - 1) % 99)
            let name = names[safe: futureDayNumber]

            guard let name = name else { continue }

            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "اسم الله اليوم 📿"
            content.body = "\(name.nameArabic) - \(name.translation)"
            content.sound = .default
            content.badge = 1

            // Calculate the exact date for this notification
            let notificationDate = calendar.date(byAdding: .day, value: dayOffset, to: Date())!
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: notificationDate)
            dateComponents.hour = hour
            dateComponents.minute = minute

            // Create trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            // Create request with unique identifier
            let request = UNNotificationRequest(
                identifier: "dailyNameNotification_day\(dayOffset)",
                content: content,
                trigger: trigger
            )

            // Schedule notification
            center.add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule notification for day \(dayOffset): \(error)")
                }
            }
        }

        print("✅ Scheduled 99 notifications starting at \(hour):\(String(format: "%02d", minute))")

        // Save notification settings
        defaults.set(true, forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)
        defaults.set("\(hour):\(minute)", forKey: AppConstants.UserDefaultsKeys.notificationTime)
    }

    // MARK: - Cancel Notifications
    func cancelNotifications() {
        center.removeAllPendingNotificationRequests()
        defaults.set(false, forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)
        print("✅ Notifications cancelled")
    }

    // MARK: - Check if Enabled
    var isEnabled: Bool {
        return defaults.bool(forKey: AppConstants.UserDefaultsKeys.notificationsEnabled)
    }

    // MARK: - Get Notification Time
    func getNotificationTime() -> (hour: Int, minute: Int) {
        let timeString = defaults.string(forKey: AppConstants.UserDefaultsKeys.notificationTime) ?? "9:0"
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        return (hour: components.first ?? 9, minute: components.last ?? 0)
    }

    // MARK: - Check Permission Status
    func checkPermissionStatus(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}
