//
//  OnboardingView.swift
//  NamesOfAllah
//
//  Main onboarding container (Apple-style)
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: NamesViewModel
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                // Top bar — skip button, right-aligned, subtle
                HStack {
                    Spacer()

                    if currentPage < 2 {
                        Button(action: {
                            viewModel.completeOnboarding()
                        }) {
                            Text("تخطي")
                                .font(.custom("IBMPlexSansArabic-Medium", size: 16))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .frame(height: 44)

                // Pages
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)

                    OnboardingPage2()
                        .tag(1)

                    OnboardingPage3(onComplete: {
                        viewModel.completeOnboarding()
                    })
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Custom page indicator — Apple style: thin pills
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Capsule()
                            .fill(
                                index == currentPage
                                    ? AppConstants.Colors.accentGold
                                    : Color.white.opacity(0.25)
                            )
                            .frame(
                                width: index == currentPage ? 24 : 8,
                                height: 6
                            )
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView(viewModel: NamesViewModel())
}
