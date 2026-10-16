//
//  OnboardingPage3.swift
//  NamesOfAllah
//
//  Third onboarding page - Get Started (Apple-style)
//

import SwiftUI

struct OnboardingPage3: View {
    let onComplete: () -> Void
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 60, maxHeight: 120)

            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 72, weight: .thin))
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

            // Title
            Text("ابدأ رحلتك")
                .font(.custom("IBMPlexSansArabic-Bold", size: 32))
                .foregroundColor(.white)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)

            Spacer()
                .frame(height: 12)

            // Subtitle
            Text("في معرفة أسماء الله الحسنى")
                .font(.custom("IBMPlexSansArabic-Medium", size: 19))
                .foregroundColor(.white.opacity(0.75))
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: showContent)

            Spacer()
                .frame(height: 28)

            // Description
            Text("تعلّم اسمًا جديدًا كل يوم\nواكتشف كيف تعيش بها في حياتك")
                .font(.custom("IBMPlexSansArabic-Regular", size: 16))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: showContent)

            Spacer()

            // CTA Button — Apple style: full-width rounded rect, bold
            Button(action: {
                HapticManager.shared.impact(style: .medium)
                onComplete()
            }) {
                Text("ابدأ الآن")
                    .font(.custom("IBMPlexSansArabic-Bold", size: 19))
                    .foregroundColor(Color(hex: "#1a1a2e"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppConstants.Colors.accentGold,
                                        Color(hex: "#f0c850")
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .shadow(color: AppConstants.Colors.accentGold.opacity(0.25), radius: 12, y: 6)
            }
            .padding(.horizontal, 32)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 16)
            .animation(.easeOut(duration: 0.6).delay(0.7), value: showContent)

            Spacer()
                .frame(minHeight: 100, maxHeight: 140)
        }
        .onAppear { showContent = true }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        OnboardingPage3(onComplete: {})
    }
}
