//
//  ThemeManager.swift
//  NamesOfAllah
//
//  Manages app themes and colors
//

import SwiftUI
import Combine

enum AppTheme: Int, CaseIterable, Identifiable {
    case classicBlue = 0
    case emeraldGreen = 1
    case royalPurple = 2
    case warmBrown = 3
    case elegantGray = 4
    case burgundyRed = 5
    case sunrise = 6
    case pureBlack = 7
    case midnightBlue = 8
    case premiumGold = 9

    var id: Int { rawValue }

    var gradient: LinearGradient {
        switch self {
        case .classicBlue:
            return LinearGradient(
                colors: [
                    Color(hex: "#1a237e"),
                    Color(hex: "#7e57c2")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .emeraldGreen:
            return LinearGradient(
                colors: [
                    Color(hex: "#0a3d0c"),
                    Color(hex: "#1b5e20")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .royalPurple:
            return LinearGradient(
                colors: [
                    Color(hex: "#4a148c"),
                    Color(hex: "#9c27b0")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .warmBrown:
            return LinearGradient(
                colors: [
                    Color(hex: "#3e2723"),
                    Color(hex: "#8d6e63")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .elegantGray:
            return LinearGradient(
                colors: [
                    Color(hex: "#263238"),
                    Color(hex: "#546e7a")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .burgundyRed:
            return LinearGradient(
                colors: [
                    Color(hex: "#4a0e0e"),
                    Color(hex: "#8b1a1a")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunrise:
            return LinearGradient(
                colors: [
                    Color(hex: "#0d1b2a"),
                    Color(hex: "#bf360c"),
                    Color(hex: "#ff6f00")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .pureBlack:
            return LinearGradient(
                colors: [
                    Color(hex: "#000000"),
                    Color(hex: "#1a1a1a")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .midnightBlue:
            return LinearGradient(
                colors: [
                    Color(hex: "#0d1b2a"),
                    Color(hex: "#1b263b")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .premiumGold:
            return LinearGradient(
                colors: [
                    Color(hex: "#1a1a2e"),
                    Color(hex: "#16213e"),
                    Color(hex: "#0f3460")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var name: String {
        switch self {
        case .classicBlue:
            return "الأزرق الكلاسيكي"
        case .emeraldGreen:
            return "الأخضر الزمردي"
        case .royalPurple:
            return "البنفسجي الملكي"
        case .warmBrown:
            return "البني الدافئ"
        case .elegantGray:
            return "الرمادي الأنيق"
        case .burgundyRed:
            return "العنابي"
        case .sunrise:
            return "شروق الشمس"
        case .pureBlack:
            return "الأسود"
        case .midnightBlue:
            return "أزرق منتصف الليل"
        case .premiumGold:
            return "الذهبي الفاخر"
        }
    }

    var previewColors: [Color] {
        switch self {
        case .classicBlue:
            return [Color(hex: "#1a237e"), Color(hex: "#7e57c2")]
        case .emeraldGreen:
            return [Color(hex: "#0a3d0c"), Color(hex: "#1b5e20")]
        case .royalPurple:
            return [Color(hex: "#4a148c"), Color(hex: "#9c27b0")]
        case .warmBrown:
            return [Color(hex: "#3e2723"), Color(hex: "#8d6e63")]
        case .elegantGray:
            return [Color(hex: "#263238"), Color(hex: "#546e7a")]
        case .burgundyRed:
            return [Color(hex: "#4a0e0e"), Color(hex: "#8b1a1a")]
        case .sunrise:
            return [Color(hex: "#0d1b2a"), Color(hex: "#ff6f00")]
        case .pureBlack:
            return [Color(hex: "#000000"), Color(hex: "#1a1a1a")]
        case .midnightBlue:
            return [Color(hex: "#0d1b2a"), Color(hex: "#1b263b")]
        case .premiumGold:
            return [Color(hex: "#1a1a2e"), Color(hex: "#f5af19")]
        }
    }

    var accentColor: Color {
        switch self {
        case .classicBlue:
            return Color(hex: "#7e57c2")
        case .emeraldGreen:
            return Color(hex: "#2d6a4f")
        case .royalPurple:
            return Color(hex: "#9c27b0")
        case .warmBrown:
            return Color(hex: "#8d6e63")
        case .elegantGray:
            return Color(hex: "#546e7a")
        case .burgundyRed:
            return Color(hex: "#c62828")
        case .sunrise:
            return Color(hex: "#ff6f00")
        case .pureBlack:
            return Color(hex: "#424242")
        case .midnightBlue:
            return Color(hex: "#415a77")
        case .premiumGold:
            return Color(hex: "#f5af19")
        }
    }

    var glowColor: Color {
        switch self {
        case .classicBlue:
            return Color(hex: "#7e57c2")
        case .emeraldGreen:
            return Color(hex: "#2d6a4f")
        case .royalPurple:
            return Color(hex: "#9c27b0")
        case .warmBrown:
            return Color(hex: "#8d6e63")
        case .elegantGray:
            return Color(hex: "#78909c")
        case .burgundyRed:
            return Color(hex: "#d32f2f")
        case .sunrise:
            return Color(hex: "#ff9800")
        case .pureBlack:
            return Color(hex: "#616161")
        case .midnightBlue:
            return Color(hex: "#778da9")
        case .premiumGold:
            return Color(hex: "#ffd700")
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @AppStorage("selectedTheme") var selectedThemeRawValue: Int = 9

    @Published var currentTheme: AppTheme = .premiumGold

    private init() {
        // Load saved theme
        if let theme = AppTheme(rawValue: selectedThemeRawValue) {
            currentTheme = theme
        }
    }

    func setTheme(_ theme: AppTheme) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTheme = theme
            selectedThemeRawValue = theme.rawValue
        }
        HapticManager.shared.impact(style: .medium)
    }
}
