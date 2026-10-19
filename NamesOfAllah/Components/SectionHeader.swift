//
//  SectionHeader.swift
//  NamesOfAllah
//
//  Section header component
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let icon: String?
    @StateObject private var themeManager = ThemeManager.shared

    init(title: String, icon: String? = nil) {
        self.title = title
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 10) {
            Spacer()

            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.accentColor)
            }

            Text(title)
                .font(.custom("IBMPlexSansArabic-Bold", size: 20))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
}

// Info Card Component
struct InfoCard: View {
    let content: String
    var backgroundColor: Color

    init(content: String, backgroundColor: Color = Color.white.opacity(0.06)) {
        self.content = content
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Text(content)
            .font(.custom("IBMPlexSansArabic-Regular", size: 16))
            .foregroundColor(.white.opacity(0.95))
            .multilineTextAlignment(.trailing)
            .lineSpacing(8)
            .fixedSize(horizontal: false, vertical: true)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .trailing)
            // Content cards use a quiet fill; Liquid Glass is reserved for controls
            .background(backgroundColor, in: .rect(cornerRadius: 20))
    }
}

// Bullet Point Card
struct BulletCard: View {
    let text: String
    let icon: String
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Spacer()

            Text(text)
                .font(.custom("IBMPlexSansArabic-Regular", size: 15))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.trailing)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(themeManager.currentTheme.accentColor)
                .frame(width: 24, height: 24)
        }
        .padding(16)
        .background(.white.opacity(0.06), in: .rect(cornerRadius: 16))
    }
}

// Decorative Islamic Pattern
struct IslamicPattern: View {
    var body: some View {
        Image(systemName: "star.and.crescent.moon")
            .font(.system(size: 80, weight: .thin))
            .foregroundColor(.white.opacity(0.05))
    }
}

#Preview {
    ZStack {
        GradientBackground()

        VStack(spacing: 20) {
            SectionHeader(title: "المعنى", icon: "book.fill")

            InfoCard(content: "هذا نص تجريبي لشرح معنى الاسم")

            BulletCard(
                text: "نقطة تجريبية للشرح",
                icon: "checkmark.circle.fill"
            )

            IslamicPattern()
        }
        .padding()
    }
}
