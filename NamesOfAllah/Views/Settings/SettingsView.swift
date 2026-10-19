//
//  SettingsView.swift
//  NamesOfAllah
//
//  Settings and about view
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: NamesViewModel
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showAbout = false
    @State private var showDisclaimer = false
    @State private var showSources = false

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    // MARK: - Header
                    HStack(spacing: 15) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 30))
                            .foregroundColor(themeManager.currentTheme.accentColor)
                            .frame(width: 64, height: 64)
                            .glassEffect(in: .circle)

                        Text("الإعدادات")
                            .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 20)

                    // MARK: - Notifications Section
                    VStack(spacing: 15) {
                        SettingsSectionHeader(title: "الإشعارات")

                        SettingsToggle(
                            title: "الإشعارات اليومية",
                            subtitle: "إشعار صباحي باسم اليوم",
                            icon: "bell.fill",
                            isOn: $viewModel.notificationsEnabled,
                            onChange: { enabled in
                                if enabled {
                                    NotificationManager.shared.requestPermission { granted in
                                        if granted {
                                            viewModel.notificationsEnabled = true
                                            viewModel.toggleNotifications()
                                        } else {
                                            viewModel.notificationsEnabled = false
                                        }
                                    }
                                } else {
                                    viewModel.toggleNotifications()
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Theme Section
                    VStack(spacing: 15) {
                        SettingsSectionHeader(title: "المظهر")

                        Menu {
                            ForEach(AppTheme.allCases) { theme in
                                Button(action: {
                                    themeManager.setTheme(theme)
                                    HapticManager.shared.selection()
                                }) {
                                    HStack {
                                        Text(theme.name)
                                            .font(.custom("IBMPlexSansArabic-Medium", size: 16))

                                        Spacer()

                                        if themeManager.currentTheme == theme {
                                            Image(systemName: "checkmark")
                                        }

                                        Circle()
                                            .fill(theme.gradient)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 15) {
                                Circle()
                                    .fill(themeManager.currentTheme.gradient)
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ثيم التطبيق")
                                        .font(.custom("IBMPlexSansArabic-Medium", size: 16))
                                        .foregroundColor(.white)

                                    Text(themeManager.currentTheme.name)
                                        .font(.custom("IBMPlexSansArabic-Regular", size: 13))
                                        .foregroundColor(.white.opacity(0.6))
                                }

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(16)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: - App Section
                    VStack(spacing: 15) {
                        SettingsSectionHeader(title: "التطبيق")

                        SettingsButton(
                            title: "عن التطبيق",
                            icon: "info.circle.fill"
                        ) {
                            showAbout = true
                        }

                        SettingsButton(
                            title: "تنبيه شرعي",
                            icon: "exclamationmark.triangle.fill"
                        ) {
                            showDisclaimer = true
                        }

                        SettingsButton(
                            title: "المصادر",
                            icon: "book.fill"
                        ) {
                            showSources = true
                        }

                        SettingsButton(
                            title: "مشاركة التطبيق",
                            icon: "square.and.arrow.up.fill"
                        ) {
                            shareApp()
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: - App Info & Credits
                    VStack(spacing: 12) {
                        // App Version
                        VStack(spacing: 4) {
                            Text(AppConstants.AppInfo.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))

                            Text("الإصدار \(AppConstants.AppInfo.version)")
                                .font(.custom("IBMPlexSansArabic-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.4))
                        }

                        // Simple Divider
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 8)

                        // Developer Credit - Simple
                        VStack(spacing: 6) {
                            Text("تطوير")
                                .font(.custom("IBMPlexSansArabic-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.5))

                            Text("Abdulaziz Alfahad")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))

                            Text("عبدالعزيز الفهد")
                                .font(.custom("IBMPlexSansArabic-Medium", size: 14))
                                .foregroundColor(Color(hex: "#ffd89b").opacity(0.7))
                        }

                        // Copyright
                        Text("© 2026 جميع الحقوق محفوظة")
                            .font(.custom("IBMPlexSansArabic-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.top, 8)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAbout) {
            InfoSheet(title: "عن التطبيق", content: AppConstants.AppInfo.description)
        }
        .sheet(isPresented: $showDisclaimer) {
            InfoSheet(title: "تنبيه شرعي", content: AppConstants.AppInfo.disclaimer)
        }
        .sheet(isPresented: $showSources) {
            InfoSheet(title: "المصادر", content: AppConstants.AppInfo.sources)
        }
    }

    func shareApp() {
        let text = """
        تطبيق أسماء الله الحسنى
        تعلّم اسماً جديداً كل يوم واكتشف كيف تعيش بها في حياتك

        https://apps.apple.com/app/id6761344902
        """

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }

        HapticManager.shared.impact(style: .light)
    }
}

// MARK: - Settings Components
struct SettingsSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("IBMPlexSansArabic-Bold", size: 18))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String?
    let icon: String
    @Binding var isOn: Bool
    let onChange: ((Bool) -> Void)?
    @StateObject private var themeManager = ThemeManager.shared

    init(title: String, subtitle: String? = nil, icon: String, isOn: Binding<Bool>, onChange: ((Bool) -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.onChange = onChange
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(themeManager.currentTheme.accentColor)
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("IBMPlexSansArabic-Medium", size: 16))
                    .foregroundColor(.white)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.custom("IBMPlexSansArabic-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(themeManager.currentTheme.accentColor)
                .onChange(of: isOn) { oldValue, newValue in
                    onChange?(newValue)
                    HapticManager.shared.selection()
                }
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        Button {
            action()
            HapticManager.shared.impact(style: .light)
        } label: {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(themeManager.currentTheme.accentColor)
                    .frame(width: 35)

                Text(title)
                    .font(.custom("IBMPlexSansArabic-Medium", size: 16))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(16)
            .contentShape(.rect)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Info Sheet
struct InfoSheet: View {
    let title: String
    let content: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 20) {
                // Header
                HStack {
                    Spacer()

                    Text(title)
                        .font(.custom("IBMPlexSansArabic-Bold", size: 24))
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .controlSize(.large)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    Text(content)
                        .font(.custom("IBMPlexSansArabic-Regular", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(8)
                        .padding(20)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Theme Color Circle
struct ThemeColorCircle: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            action()
            // Scale animation on tap
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 0.85
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    // Gradient circle
                    Circle()
                        .fill(theme.gradient)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ?
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#ffd89b"),
                                            Color(hex: "#f8d800")
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: isSelected ? 3 : 1
                                )
                        )
                        .shadow(
                            color: isSelected ? Color(hex: "#ffd89b").opacity(0.5) : .clear,
                            radius: isSelected ? 10 : 0,
                            x: 0,
                            y: 0
                        )

                    // Checkmark for selected theme
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
                .scaleEffect(scale)

                // Theme name
                Text(theme.name)
                    .font(.custom(isSelected ? "IBMPlexSansArabic-SemiBold" : "IBMPlexSansArabic-Medium", size: 11))
                    .foregroundColor(isSelected ? Color(hex: "#ffd89b") : .white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(theme.name)\(isSelected ? "، محدد" : "")")
    }
}

#Preview {
    SettingsView(viewModel: NamesViewModel())
        .environment(\.layoutDirection, .rightToLeft)
}
