//
//  NamesOfAllahApp.swift
//  NamesOfAllah
//
//  Created by Abdulaziz Alfahad on 22/05/1447 AH.
//

import SwiftUI
import CoreText
import WidgetKit

@main
struct NamesOfAllahApp: App {
    init() {
        // Configure for RTL (Right-to-Left) support
        if #available(iOS 16.0, *) {
            // iOS 16+ handles RTL automatically
        }

        // Disable horizontal bounce globally
        UIScrollView.appearance().bounces = true
        UIScrollView.appearance().alwaysBounceHorizontal = false
        UIScrollView.appearance().showsHorizontalScrollIndicator = false

        // Load custom fonts programmatically
        loadCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.layoutDirection, .rightToLeft)
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
    }

    // MARK: - Font Loading

    private func loadCustomFonts() {
        print("\n🎨 Loading Custom Fonts...")
        print("==========================")

        let fontNames = [
            "IBMPlexSansArabic-Regular",
            "IBMPlexSansArabic-Bold",
            "IBMPlexSansArabic-Medium",
            "IBMPlexSansArabic-SemiBold"
        ]

        for fontName in fontNames {
            loadFont(name: fontName)
        }

        print("==========================\n")
    }

    private func loadFont(name: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: "ttf") else {
            print("❌ Font file not found: \(name).ttf")
            return
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            print("✅ Successfully loaded: \(name)")
        } else {
            // Font might already be registered
            print("ℹ️  Already registered: \(name)")
        }
    }
}
