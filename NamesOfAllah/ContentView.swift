//
//  ContentView.swift
//  NamesOfAllah
//
//  Main content view with tab navigation
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NamesViewModel()

    var body: some View {
        ZStack {
            // Main Tab View
            if !viewModel.showOnboarding {
                MainTabView(viewModel: viewModel)
            }

            // Onboarding Overlay
            if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.showOnboarding)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @ObservedObject var viewModel: NamesViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeView(viewModel: viewModel)
                case .list:
                    AllNamesView(viewModel: viewModel)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTab)

            // Custom Tab Bar
            CustomTabBar(selectedTab: $viewModel.selectedTab)
                .padding(.bottom, 0)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Custom Tab Bar (iOS 26 Style)
struct CustomTabBar: View {
    @Binding var selectedTab: NamesViewModel.Tab
    @StateObject private var themeManager = ThemeManager.shared
    @State private var indicatorOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NamesViewModel.Tab.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                        HapticManager.shared.selection()
                    }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            ZStack {
                // Modern blur effect (iOS 26 style)
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#1a1a2e").opacity(0.85),
                                        Color(hex: "#16213e").opacity(0.85)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )

                // Subtle gradient overlay with theme color
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#ffd89b").opacity(0.08),
                                Color.clear,
                                themeManager.currentTheme.glowColor.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Border with theme accent
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                themeManager.currentTheme.accentColor.opacity(0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: themeManager.currentTheme.glowColor.opacity(0.3), radius: 20, x: 0, y: 10)
        .shadow(color: themeManager.currentTheme.glowColor.opacity(0.15), radius: 30, x: 0, y: 5)
        .shadow(color: .black.opacity(0.4), radius: 25, x: 0, y: 15)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .animation(.easeInOut(duration: 0.3), value: themeManager.currentTheme)
    }
}

// MARK: - Tab Bar Item (iOS 26 Style)
struct TabBarItem: View {
    let tab: NamesViewModel.Tab
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 26 : 22, weight: .semibold))
                    .foregroundStyle(
                        isSelected ?
                        LinearGradient(
                            colors: [
                                themeManager.currentTheme.accentColor,
                                themeManager.currentTheme.glowColor
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ) :
                        LinearGradient(
                            colors: [.white.opacity(0.7), .white.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(tab.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? themeManager.currentTheme.accentColor : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(
                ZStack {
                    if isSelected {
                        // Modern pill background with theme colors
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.currentTheme.accentColor.opacity(0.2),
                                        themeManager.currentTheme.glowColor.opacity(0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                themeManager.currentTheme.accentColor.opacity(0.4),
                                                themeManager.currentTheme.glowColor.opacity(0.2)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: themeManager.currentTheme.glowColor.opacity(0.3), radius: 8, x: 0, y: 2)
                    }
                }
            )
            .scaleEffect(isSelected ? 1.0 : 0.95)
            .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
