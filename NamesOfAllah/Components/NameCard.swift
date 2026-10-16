//
//  NameCard.swift
//  NamesOfAllah
//
//  Premium card component for displaying a name
//

import SwiftUI
import Foundation

struct NameCard: View {
    let name: Name
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    @State private var isPressed = false
    @State private var shimmerPhase: CGFloat = 0

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            // Arabic Name with glow
            HStack {
                Spacer()
                Text(name.nameArabic)
                    .font(.custom("DiwanMishafi", size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(hex: "#ffd89b")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: "#ffd89b").opacity(0.3), radius: 10, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            }

            // English Name & Translation
            HStack(spacing: 15) {
                // Favorite Button with animation
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onFavoriteToggle()
                    }
                    HapticManager.shared.impact(style: .light)
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isFavorite ? [
                                        themeManager.currentTheme.accentColor,
                                        themeManager.currentTheme.glowColor
                                    ] : [
                                        Color.white.opacity(0.1),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: isFavorite ? themeManager.currentTheme.accentColor.opacity(0.5) : .clear, radius: 10, x: 0, y: 5)

                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(isFavorite ? .white : .white.opacity(0.8))
                            .scaleEffect(isFavorite ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text(name.nameEnglish)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))

                    Text(name.translation)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "#ffd89b").opacity(0.8))
                }
            }
        }
        .padding(24)
        .background(
            ZStack {
                // Premium glassmorphism background
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )

                // Shimmer effect
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.15),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(45))
                    .offset(x: shimmerPhase)
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                            shimmerPhase = 400
                        }
                    }
            }
        )
        .shadow(color: themeManager.currentTheme.glowColor.opacity(0.15), radius: 20, x: 0, y: 10)
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// Compact version for list view with premium design
struct NameCard_Compact: View {
    let name: Name
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack(spacing: 15) {
            // Arabic Name
            Text(name.nameArabic)
                .font(.custom("DiwanMishafi", size: 24))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(hex: "#ffd89b").opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Spacer()

            // English & Translation
            VStack(alignment: .trailing, spacing: 4) {
                Text(name.nameEnglish)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))

                Text(name.translation)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#ffd89b").opacity(0.7))
            }

            // Favorite Button
            Button(action: {
                onFavoriteToggle()
                HapticManager.shared.impact(style: .light)
            }) {
                ZStack {
                    Circle()
                        .fill(
                            isFavorite ?
                            LinearGradient(
                                colors: [themeManager.currentTheme.accentColor, themeManager.currentTheme.glowColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)

                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

// Favorites version
struct NameCard_Favorites: View {
    let name: Name
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 6) {
                Text(name.nameArabic)
                    .font(.custom("DiwanMishafi", size: 24))
                    .foregroundColor(.white)

                Text(name.nameEnglish)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))

                Text(name.translation)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#ffd89b").opacity(0.7))
            }

            Spacer()

            Button(action: {
                onFavoriteToggle()
                HapticManager.shared.impact(style: .light)
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isFavorite ? themeManager.currentTheme.accentColor : .white.opacity(0.5))
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
}

#Preview {
    ZStack {
        GradientBackground()
        FloatingParticles()

        VStack(spacing: 20) {
            NameCard(
                name: Name.sample,
                isFavorite: false,
                onFavoriteToggle: {}
            )

            NameCard_Compact(
                name: Name.sample,
                isFavorite: true,
                onFavoriteToggle: {}
            )
        }
        .padding()
    }
}
