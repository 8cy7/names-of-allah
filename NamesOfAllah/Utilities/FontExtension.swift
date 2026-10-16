//
//  FontExtension.swift
//  NamesOfAllah
//
//  Custom font extension for IBM Plex Sans Arabic
//

import SwiftUI

extension Font {
    // IBM Plex Sans Arabic font family
    static func ibmArabic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String

        switch weight {
        case .bold, .heavy, .black:
            fontName = "IBMPlexSansArabic-Bold"
        case .semibold:
            fontName = "IBMPlexSansArabic-SemiBold"
        case .medium:
            fontName = "IBMPlexSansArabic-Medium"
        default:
            fontName = "IBMPlexSansArabic-Regular"
        }

        return .custom(fontName, size: size)
    }
}
