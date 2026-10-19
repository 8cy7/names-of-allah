//
//  AllNamesView.swift
//  NamesOfAllah
//
//  List view showing all names with search and filters
//

import SwiftUI

struct AllNamesView: View {
    @ObservedObject var viewModel: NamesViewModel
    @ObservedObject private var dataManager = DataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedName: Name?
    @State private var showDetail = false

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 15) {
                    // Title
                    Text("أسماء الله الحسنى")
                        .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Progress
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.currentTheme.accentColor)

                        Text("تعلمت \(dataManager.completedCount.arabicDigits) من \(dataManager.names.count.arabicDigits)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .glassEffect()

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.5))

                        TextField("ابحث عن اسم...", text: $viewModel.searchText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)

                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .glassEffect()
                    .padding(.horizontal, 20)

                    // Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        GlassEffectContainer(spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(NamesViewModel.NameFilter.allCases, id: \.self) { filter in
                                    FilterChip(
                                        title: filter.rawValue,
                                        isSelected: viewModel.selectedFilter == filter,
                                        action: {
                                            viewModel.selectedFilter = filter
                                            HapticManager.shared.selection()
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.bottom, 15)

                // MARK: - Names List
                if viewModel.filteredNames.isEmpty {
                    // Empty State
                    VStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.3))

                        Text(viewModel.searchText.isEmpty ? "لا توجد أسماء" : "لا توجد نتائج")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredNames) { name in
                                Button(action: {
                                    selectedName = name
                                    showDetail = true
                                    HapticManager.shared.impact(style: .light)
                                }) {
                                    NameCard_Compact(
                                        name: name,
                                        isFavorite: dataManager.isFavorite(id: name.id),
                                        onFavoriteToggle: {
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
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                // Selected chip gets a theme-tinted glass; others stay clear
                .glassEffect(
                    isSelected
                        ? .regular.tint(themeManager.currentTheme.accentColor.opacity(0.6)).interactive()
                        : .regular.interactive()
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    AllNamesView(viewModel: NamesViewModel())
        .environment(\.layoutDirection, .rightToLeft)
}
