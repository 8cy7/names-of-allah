//
//  HomeView.swift
//  NamesOfAllah
//
//  Premium home screen showing name of the day - Full Screen (No Scroll)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HomeView: View {
    @ObservedObject var viewModel: NamesViewModel
    @State private var showDetail = false
    @State private var selectedName: Name?
    @State private var iconRotation: Double = 0
    @State private var iconScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0
    @State private var showContent = false

    var nameOfDay: Name? {
        DataManager.shared.getNameOfDay()
    }

    var body: some View {
        ZStack {
            // Background extends under the status bar and tab bar
            GradientBackground()
                .ignoresSafeArea()

            if let name = nameOfDay {
                // Full screen without scroll - perfectly centered
                VStack(spacing: 0) {
                    // Flexible spacers above and below keep the content centered on any screen height
                    Spacer(minLength: 24)

                    // Day Counter
                    Text("اليوم \(DataManager.shared.getCurrentDayNumber().arabicDigits) من ٩٩")
                        .font(.custom("IBMPlexSansArabic-SemiBold", size: 16))
                        .foregroundColor(Color(hex: "#ffd89b").opacity(0.9))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .glassEffect(.regular.tint(Color(hex: "#ffd89b").opacity(0.12)))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)

                    Spacer()
                        .frame(height: 40)

                    // Islamic Icon
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 50, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#ffd89b"),
                                    Color(hex: "#f8d800")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 110, height: 110)
                        .glassEffect(in: .circle)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: showContent)

                    Spacer()
                        .frame(height: 45)

                    // Arabic Name with stunning effects - Diwan Mishafi (Quranic Mushaf Font)
                    Text(name.nameArabic)
                        .font(.custom("DiwanMishafi", size: 100))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .white,
                                    Color(hex: "#ffd89b"),
                                    .white
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color(hex: "#ffd89b").opacity(0.3), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5), value: showContent)

                    Spacer()
                        .frame(height: 15)

                    // English Name with gradient
                    Text(name.nameEnglish)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.95),
                                    Color(hex: "#ffd89b").opacity(0.9)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 15)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: showContent)

                    Spacer()
                        .frame(height: 8)

                    // Translation
                    Text(name.translation)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "#ffd89b").opacity(0.7))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 15)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: showContent)

                    Spacer()
                        .frame(height: 50)

                    // "Learn More" Button
                    Button(action: {
                        selectedName = name
                        showDetail = true
                        #if canImport(UIKit)
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        #endif
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 18, weight: .semibold))

                            Text("اعرف المزيد")
                                .font(.custom("IBMPlexSansArabic-Bold", size: 19))
                        }
                        .foregroundStyle(Color(hex: "#ffd89b"))
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(.glass(.regular.tint(Color(hex: "#ffd89b").opacity(0.15)).interactive()))
                    .controlSize(.large)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.9), value: showContent)

                    Spacer()
                        .frame(height: 20)

                    // Decorative divider
                    HStack(spacing: 20) {
                        ForEach(0..<5) { i in
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#ffd89b").opacity(0.6),
                                            Color(hex: "#ffd89b").opacity(0.2)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 4, height: 4)
                                
                                .opacity(showContent ? 1 : 0)
                                .scaleEffect(showContent ? 1 : 0.5)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(1.0 + Double(i) * 0.05), value: showContent)
                        }
                    }

                    Spacer()
                }
                .onAppear {
                    showContent = true
                }
            } else {
                // Loading or error state
                VStack(spacing: 25) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#ffd89b"), Color(hex: "#f8d800")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color(hex: "#ffd89b").opacity(0.5), radius: 20, x: 0, y: 0)

                    Text("لا يوجد أسماء متاحة")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        #if os(iOS)
        .fullScreenCover(item: $selectedName) { name in
            NameDetailView(name: name, viewModel: viewModel)
        }
        #else
        .sheet(item: $selectedName) { name in
            NameDetailView(name: name, viewModel: viewModel)
        }
        #endif
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView(viewModel: NamesViewModel())
}
