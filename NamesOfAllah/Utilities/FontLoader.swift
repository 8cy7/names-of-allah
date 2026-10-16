//
//  FontLoader.swift
//  NamesOfAllah
//
//  Loads custom fonts at runtime using CTFontManager
//

import Foundation
import CoreText
#if canImport(UIKit)
import UIKit
#endif

class FontLoader {
    static func loadCustomFonts() {
        let fontNames = [
            "IBMPlexSansArabic-Regular",
            "IBMPlexSansArabic-Bold",
            "IBMPlexSansArabic-Medium",
            "IBMPlexSansArabic-SemiBold"
        ]

        for fontName in fontNames {
            loadFont(name: fontName)
        }
    }

    private static func loadFont(name: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: "ttf") else {
            print("❌ Font file not found: \(name).ttf")
            return
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("❌ Could not create data provider for: \(name)")
            return
        }

        guard let font = CGFont(fontDataProvider) else {
            print("❌ Could not create font from: \(name)")
            return
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &error) {
            if let postScriptName = font.postScriptName {
                print("✅ Successfully loaded font: \(postScriptName)")
            }
        } else {
            if let postScriptName = font.postScriptName {
                print("ℹ️  Font already registered or loaded: \(postScriptName)")
            }
        }
    }

    #if canImport(UIKit)
    static func printLoadedIBMFonts() {
        print("\n📝 Checking loaded IBM fonts:")

        let possibleNames = [
            "IBMPlexSansArabic-Regular",
            "IBMPlexSansArabic-Bold",
            "IBMPlexSansArabic-Medium",
            "IBMPlexSansArabic-SemiBold",
        ]

        for name in possibleNames {
            if let font = UIFont(name: name, size: 12) {
                print("✅ \(name) - Available (PostScript: \(font.fontName))")
            } else {
                print("❌ \(name) - Not available")
            }
        }
    }
    #endif
}
