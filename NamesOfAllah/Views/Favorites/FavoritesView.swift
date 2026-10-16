//
//  FavoritesView.swift
//  NamesOfAllah
//
//  Favorites view showing user's favorite names
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: NamesViewModel
    @ObservedObject private var dataManager = DataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedName: Name?
    @State private var showDetail = false
    @State private var pendingRemovals: Set<Int> = []

    var favoriteNames: [Name] {
        // Show items that are either favorited OR pending removal (so they stay visible until user navigates away)
        return dataManager.names.filter { name in
            dataManager.favoriteIDs.contains(name.id) || pendingRemovals.contains(name.id)
        }
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 15) {
                    // Title
                    HStack {
                        Text("المفضلة")
                            .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    // Count
                    if !favoriteNames.isEmpty {
                        Text("\(favoriteNames.count.arabicDigits) اسم")
                            .font(.custom("IBMPlexSansArabic-Medium", size: 15))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.bottom, 20)

                // MARK: - Content
                if favoriteNames.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))

                        VStack(spacing: 8) {
                            Text("لم تضف أي أسماء للمفضلة بعد")
                                .font(.custom("IBMPlexSansArabic-SemiBold", size: 18))
                                .foregroundColor(.white.opacity(0.8))

                            Text("اضغط على ♡ لإضافة اسم للمفضلة")
                                .font(.custom("IBMPlexSansArabic-Regular", size: 15))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 100)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(favoriteNames) { name in
                                Button(action: {
                                    selectedName = name
                                    showDetail = true
                                    HapticManager.shared.impact(style: .light)
                                }) {
                                    NameCard_Favorites(
                                        name: name,
                                        isFavorite: dataManager.isFavorite(id: name.id),
                                        onFavoriteToggle: {
                                            let isFavorited = dataManager.isFavorite(id: name.id)
                                            if isFavorited {
                                                // Item is currently favorited, will be unfavorited
                                                // Add to pendingRemovals so it stays visible until user navigates away
                                                pendingRemovals.insert(name.id)
                                            } else if pendingRemovals.contains(name.id) {
                                                // Item was unfavorited but user is re-favoriting it
                                                pendingRemovals.remove(name.id)
                                            }
                                            viewModel.toggleFavorite(id: name.id)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .id("\(name.id)-\(dataManager.favoriteIDs.contains(name.id))")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(item: $selectedName) { name in
            NameDetailView(name: name, viewModel: viewModel)
        }
        .onDisappear {
            // Clear pending removals when user navigates away
            // This commits the removals permanently
            pendingRemovals.removeAll()
        }
    }
}

#Preview {
    FavoritesView(viewModel: NamesViewModel())
}
