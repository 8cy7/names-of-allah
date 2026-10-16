//
//  ShareOptionsSheet.swift
//  NamesOfAllah
//
//  Custom share options dialog
//

import SwiftUI

enum ShareOption {
    case text
    case squareImage
    case storyImage
}

struct ShareOptionsSheet: View {
    let name: Name
    let onSelect: (ShareOption) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    Text("اختر طريقة المشاركة")
                        .font(.custom("IBMPlexSansArabic-Bold", size: 20))
                        .foregroundColor(.white)

                    Text("شارك اسم الله \(name.nameArabic)")
                        .font(.custom("IBMPlexSansArabic-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
                .multilineTextAlignment(.center)
                .padding(.top, 20)

                // Options
                VStack(spacing: 12) {
                    ShareOptionButton(title: "مشاركة كنص", icon: "doc.text.fill") {
                        onSelect(.text)
                    }

                    ShareOptionButton(title: "مشاركة كصورة", icon: "photo.fill") {
                        onSelect(.squareImage)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ShareOptionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Spacer()

                Text(title)
                    .font(.custom("IBMPlexSansArabic-SemiBold", size: 16))
                    .foregroundColor(.white)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(themeManager.currentTheme.accentColor)
                    .frame(width: 30)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
    }
}
