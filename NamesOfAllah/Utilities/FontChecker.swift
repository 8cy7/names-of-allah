//
//  FontChecker.swift
//  NamesOfAllah
//
//  Utility to list all available fonts in iOS
//

#if canImport(UIKit)
import UIKit

class FontChecker {
    static func printAllAvailableFonts() {
        print("📝 All Available Fonts in iOS:")
        print("================================")

        for family in UIFont.familyNames.sorted() {
            print("\n🔤 Font Family: \(family)")

            let names = UIFont.fontNames(forFamilyName: family)
            for name in names {
                print("   - \(name)")
            }
        }

        print("\n================================")
        print("✅ Total Font Families: \(UIFont.familyNames.count)")
    }

    static func checkIfFontExists(_ fontName: String) -> Bool {
        let font = UIFont(name: fontName, size: 12)
        let exists = font != nil
        print("🔍 Font '\(fontName)': \(exists ? "✅ EXISTS" : "❌ NOT FOUND")")
        if !exists {
            print("   Falling back to: \(UIFont.systemFont(ofSize: 12).fontName)")
        }
        return exists
    }

    static func checkIBMFonts() {
        print("\n🔎 Checking IBM Plex Sans Arabic Fonts:")
        print("========================================")

        let ibmFonts = [
            "IBMPlexSansArabic-Regular",
            "IBMPlexSansArabic-Bold",
            "IBMPlexSansArabic-Medium",
            "IBMPlexSansArabic-SemiBold",
            "IBM Plex Sans Arabic",
            "IBMPlexSansArabic"
        ]

        for fontName in ibmFonts {
            checkIfFontExists(fontName)
        }

        // Search for IBM in all available fonts
        print("\n🔍 Searching for 'IBM' in all font families:")
        for family in UIFont.familyNames.sorted() {
            if family.contains("IBM") || family.contains("Plex") {
                print("\n✨ Found: \(family)")
                let names = UIFont.fontNames(forFamilyName: family)
                for name in names {
                    print("   - \(name)")
                }
            }
        }
        print("========================================\n")
    }
}
#endif
