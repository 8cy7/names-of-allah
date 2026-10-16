//
//  OnboardingPage1.swift
//  NamesOfAllah
//
//  First onboarding page - Hadith (Apple-style)
//

import SwiftUI

struct OnboardingPage1: View {
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 60, maxHeight: 120)

            // Large SF Symbol — Apple style: big, centered, breathing room
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            AppConstants.Colors.accentGold,
                            AppConstants.Colors.accentGold.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: AppConstants.Colors.accentGold.opacity(0.3), radius: 20)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                .animation(.easeOut(duration: 0.7).delay(0.1), value: showContent)

            Spacer()
                .frame(height: 48)

            // Subtitle label — small, gold, uppercase feel
            Text("الحديث الشريف")
                .font(.custom("IBMPlexSansArabic-SemiBold", size: 15))
                .tracking(1.5)
                .foregroundColor(AppConstants.Colors.accentGold.opacity(0.8))
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)

            Spacer()
                .frame(height: 20)

            // Main text — Apple uses large title, centered, generous line spacing
            Text("إن لله تسعة وتسعين اسمًا\nمائة إلا واحدًا\nمن أحصاها دخل الجنة")
                .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)
                .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)

            Spacer()
                .frame(height: 24)

            // Source — subtle, understated
            Text("رواه البخاري ومسلم")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.4))
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.7), value: showContent)

            Spacer()
            Spacer()
                .frame(minHeight: 120, maxHeight: 160)
        }
        .onAppear { showContent = true }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        OnboardingPage1()
    }
}
