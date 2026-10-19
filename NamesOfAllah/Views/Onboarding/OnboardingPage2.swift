//
//  OnboardingPage2.swift
//  NamesOfAllah
//
//  Second onboarding page - Meaning of "Ahsaha" (Apple-style)
//

import SwiftUI

struct OnboardingPage2: View {
    @State private var showContent = false

    let meanings: [(String, String)] = [
        ("١", "حفظها ومعرفة معانيها"),
        ("٢", "فهمها والتدبر فيها"),
        ("٣", "الدعاء بها"),
        ("٤", "العمل بمقتضاها والتعبد لله بها")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 60, maxHeight: 120)

            // Icon — clean, single symbol
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: 52, weight: .light))
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
                .frame(width: 110, height: 110)
                .glassEffect(in: .circle)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                .animation(.easeOut(duration: 0.7).delay(0.1), value: showContent)

            Spacer()
                .frame(height: 48)

            // Title
            Text("معنى \"أحصاها\"")
                .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                .foregroundColor(.white)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)

            Spacer()
                .frame(height: 36)

            // Meanings list — Apple style: clean rows, no heavy cards
            VStack(spacing: 16) {
                ForEach(Array(meanings.enumerated()), id: \.offset) { index, meaning in
                    HStack(spacing: 16) {
                        // In RTL context: first item goes to trailing (right), last to leading (left)
                        // So: Text first (appears right), then Number (appears left) — WRONG
                        // We need: Number right, Text left
                        // In RTL HStack: items are laid out right-to-left
                        // So first item = rightmost = Number badge ✓
                        Text(meaning.0)
                            .font(.custom("IBMPlexSansArabic-Bold", size: 17))
                            .foregroundColor(AppConstants.Colors.accentGold)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(AppConstants.Colors.accentGold.opacity(0.12))
                            )

                        Text(meaning.1)
                            .font(.custom("IBMPlexSansArabic-Medium", size: 17))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.trailing)

                        Spacer()
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.5).delay(0.4 + Double(index) * 0.1),
                        value: showContent
                    )
                }
            }
            .padding(.horizontal, 40)

            Spacer()
                .frame(height: 24)

            // Source
            Text("شرح العلماء")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.4))
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.9), value: showContent)

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
        OnboardingPage2()
    }
}
