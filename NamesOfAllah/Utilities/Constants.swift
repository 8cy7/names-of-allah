//
//  Constants.swift
//  NamesOfAllah
//
//  App-wide constants
//

import SwiftUI

enum AppConstants {
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let favoriteNames = "favoriteNames"
        static let currentDayIndex = "currentDayIndex"
        static let lastOpenDate = "lastOpenDate"
        static let completedNames = "completedNames"
        static let notificationsEnabled = "notificationsEnabled"
        static let notificationTime = "notificationTime"
        static let fontSize = "fontSize"
        static let isDarkMode = "isDarkMode"
    }

    // MARK: - Colors
    enum Colors {
        static let primaryBlue = Color(hex: "#1a237e")
        static let primaryPurple = Color(hex: "#7e57c2")
        static let accentGold = Color(hex: "#ffd700")
        static let backgroundDark = Color(hex: "#0a0e27")

        static let gradientStart = Color(hex: "#1a237e")
        static let gradientMiddle = Color(hex: "#4a148c")
        static let gradientEnd = Color(hex: "#6a1b9a")
    }

    // MARK: - Font Sizes
    enum FontSize: CGFloat, CaseIterable {
        case small = 14
        case medium = 16
        case large = 18
        case extraLarge = 20

        var displayName: String {
            switch self {
            case .small: return "صغير"
            case .medium: return "متوسط"
            case .large: return "كبير"
            case .extraLarge: return "كبير جداً"
            }
        }
    }

    // MARK: - Animation
    enum Animation {
        static let standardDuration: Double = 0.3
        static let slowDuration: Double = 0.5
        static let fastDuration: Double = 0.2
    }

    // MARK: - App Info
    enum AppInfo {
        static let name = "أسماء الله الحسنى"
        static let version = "1.1"
        static let email = "support@namesofallah.app"
        static let description = """
        تطبيق أسماء الله الحسنى يساعدك على معرفة وفهم أسماء الله الحسنى التسعة والتسعين، مع شرح معانيها وكيفية العيش بها في حياتك اليومية.
        """
        static let disclaimer = """
        تنبيه شرعي:
        المحتوى المقدم في هذا التطبيق مأخوذ من مصادر موثوقة، لكن يُنصح دائماً بالرجوع إلى أهل العلم المعتبرين لفهم أعمق. نسأل الله أن يجعل هذا العمل خالصاً لوجهه الكريم.
        """
        static let sources = """
        المصادر:
        • القرآن الكريم
        • صحيح البخاري
        • صحيح مسلم
        • شرح أسماء الله الحسنى - الشيخ عبدالرحمن السعدي
        • فقه الأسماء الحسنى - الشيخ عبدالرزاق البدر
        """
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
