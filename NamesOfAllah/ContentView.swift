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
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        // System tab bar renders with Liquid Glass automatically on iOS 26
        TabView(selection: $viewModel.selectedTab) {
            Tab(NamesViewModel.Tab.home.rawValue, systemImage: NamesViewModel.Tab.home.icon, value: .home) {
                HomeView(viewModel: viewModel)
            }
            Tab(NamesViewModel.Tab.list.rawValue, systemImage: NamesViewModel.Tab.list.icon, value: .list) {
                AllNamesView(viewModel: viewModel)
            }
            Tab(NamesViewModel.Tab.favorites.rawValue, systemImage: NamesViewModel.Tab.favorites.icon, value: .favorites) {
                FavoritesView(viewModel: viewModel)
            }
            Tab(NamesViewModel.Tab.settings.rawValue, systemImage: NamesViewModel.Tab.settings.icon, value: .settings) {
                SettingsView(viewModel: viewModel)
            }
        }
        .tint(themeManager.currentTheme.accentColor)
        .onChange(of: viewModel.selectedTab) {
            HapticManager.shared.selection()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

#Preview("Main Tabs") {
    MainTabView(viewModel: NamesViewModel())
        .environment(\.layoutDirection, .rightToLeft)
}
