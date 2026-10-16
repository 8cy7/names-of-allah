//
//  NameDetailView.swift
//  NamesOfAllah
//
//  Detailed view for a single name
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct NameDetailView: View {
    let name: Name
    @ObservedObject var viewModel: NamesViewModel
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var isFavorite = false
    @State private var showShareOptions = false
    @State private var shareItems: [Any] = []
    @State private var showShareSheet = false
    @State private var showRewardMessage = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var showConfetti = false

    var body: some View {
        GeometryReader { geo in
        ZStack {
            GradientBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    // MARK: - Header Section
                    VStack(spacing: 15) {
                        // Close button and Favorite
                        HStack {
                            // Share Button
                            Button(action: {
                                showShareOptions = true
                                HapticManager.shared.impact(style: HapticManager.ImpactStyle.light)
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }

                            Spacer()

                            // Favorite Button
                            Button(action: {
                                isFavorite.toggle()
                                viewModel.toggleFavorite(id: name.id)
                                HapticManager.shared.impact(style: HapticManager.ImpactStyle.light)
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 22))
                                    .foregroundColor(isFavorite ? .red : .white.opacity(0.7))
                                    .scaleEffect(isFavorite ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }

                            // Close Button
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 55)

                        // Name Header
                        VStack(spacing: 12) {
                            Text(name.nameArabic)
                                .font(.custom("DiwanMishafi", size: 48))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity)

                            Text(name.nameEnglish)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))

                            Text(name.translation)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))

                            Text("اليوم \(name.id.arabicDigits) من ٩٩")
                                .font(.custom("IBMPlexSansArabic-SemiBold", size: 14))
                                .foregroundColor(themeManager.currentTheme.accentColor)
                                .padding(.top, 5)
                        }
                        .padding(.vertical, 20)
                    }

                    // MARK: - Meaning Section
                    VStack(alignment: .trailing, spacing: 15) {
                        SectionHeader(title: "المعنى", icon: "book.fill")

                        InfoCard(content: name.meaning)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Evidence Section
                    VStack(alignment: .trailing, spacing: 15) {
                        SectionHeader(title: "الدليل", icon: "text.book.closed.fill")

                        InfoCard(
                            content: name.evidence,
                            backgroundColor: themeManager.currentTheme.accentColor.opacity(0.1)
                        )
                    }
                    .padding(.horizontal, 20)

                    // MARK: - How to Live It Section
                    VStack(alignment: .trailing, spacing: 15) {
                        SectionHeader(title: "كيف تعيش هذا الاسم", icon: "lightbulb.fill")

                        ForEach(Array(name.liveIt.enumerated()), id: \.offset) { _, item in
                            BulletCard(text: item, icon: "checkmark.circle.fill")
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Story Section
                    VStack(alignment: .trailing, spacing: 15) {
                        SectionHeader(title: "قصة", icon: "text.quote")

                        InfoCard(
                            content: name.story,
                            backgroundColor: Color.white.opacity(0.05)
                        )
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Mark as Completed Button
                    if !DataManager.shared.isCompleted(id: name.id) {
                        Button(action: {
                            // Animation sequence
                            HapticManager.shared.notification(type: HapticManager.NotificationType.success)

                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                buttonScale = 0.85
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    buttonScale = 1.0
                                    showConfetti = true
                                }

                                viewModel.markAsCompleted(id: name.id)

                                // Show reward message
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showRewardMessage = true
                                }

                                // Hide confetti
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showConfetti = false
                                }
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 18, weight: .semibold))

                                Text("تم الإحصاء")
                                    .font(.custom("IBMPlexSansArabic-SemiBold", size: 17))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                themeManager.currentTheme.accentColor,
                                                themeManager.currentTheme.glowColor
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: themeManager.currentTheme.glowColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                        }
                        .scaleEffect(buttonScale)
                        .padding(.top, 10)
                    } else {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))

                            Text("تم الإحصاء")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(themeManager.currentTheme.accentColor)
                        .padding(.top, 10)
                    }

                    // Bottom spacing
                    Spacer()
                        .frame(height: 40)
                }
            }
            // MARK: - Reward Message Overlay
            if showRewardMessage {
                ZStack {
                    // Dark overlay - tap to dismiss
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showRewardMessage = false
                            }
                        }

                    // Celebration particles
                    CelebrationParticlesView()
                        .allowsHitTesting(false)

                    VStack {
                        Spacer()

                        // Liquid Glass card - bottom sheet style
                        VStack(spacing: 20) {
                            // Drag indicator
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 36, height: 4)
                                .padding(.top, 12)

                            // Checkmark circle
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 64, height: 64)

                                Image(systemName: "checkmark")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            // Title
                            Text("تم الإحصاء")
                                .font(.custom("IBMPlexSansArabic-Bold", size: 22))
                                .foregroundColor(.white)

                            // Hadith
                            VStack(spacing: 6) {
                                Text("«من سلك طريقًا يلتمس فيه علمًا سهّل الله له به طريقًا إلى الجنة»")
                                    .font(.custom("IBMPlexSansArabic-Regular", size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)

                                Text("رواه مسلم")
                                    .font(.custom("IBMPlexSansArabic-Regular", size: 11))
                                    .foregroundColor(.white.opacity(0.25))
                            }
                            .padding(.horizontal, 16)

                            // Dismiss button
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    showRewardMessage = false
                                }
                            }) {
                                Text("متابعة")
                                    .font(.custom("IBMPlexSansArabic-SemiBold", size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                // Frosted glass background
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(.ultraThinMaterial)

                                // Subtle tint
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color(hex: "#0a0e27").opacity(0.5))
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .transition(.opacity)
            }

            
        }
        .frame(width: geo.size.width)
        .clipped()
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onAppear {
            isFavorite = DataManager.shared.isFavorite(id: name.id)
        }
        .sheet(isPresented: $showShareOptions) {
            ShareOptionsSheet(name: name) { option in
                showShareOptions = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    switch option {
                    case .text: shareAsText()
                    case .squareImage: shareAsSquareImage()
                    default: break
                    }
                }
            }
            #if os(iOS)
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
            #endif
        }
        .sheet(isPresented: $showShareSheet) {
            #if canImport(UIKit)
            if #available(iOS 16.0, *) {
                ActivityViewController(activityItems: shareItems)
                    .presentationDetents([.medium, .large])
            } else {
                ActivityViewController(activityItems: shareItems)
            }
            #else
            // macOS fallback - simple text view
            VStack {
                Text("Share Content")
                    .font(.headline)
                    .padding()
                
                if let text = shareItems.first as? String {
                    ScrollView {
                        Text(text)
                            .padding()
                            .textSelection(.enabled)
                    }
                }
                
                Button("Done") {
                    showShareSheet = false
                }
                .padding()
            }
            .frame(width: 400, height: 300)
            #endif
        }
    }

    // MARK: - Share Functions

    func shareAsText() {
        let text = ShareHelper.shareText(name: name)
        shareItems = [text]
        showShareSheet = true
        HapticManager.shared.impact(style: HapticManager.ImpactStyle.medium)
    }

    func shareAsSquareImage() {
        Task { @MainActor in
            let squareView = SquareShareView(name: name)
            if let image = ShareHelper.generateImage(from: squareView, size: CGSize(width: 1080, height: 1080)) {
                shareItems = [image]
                showShareSheet = true
                HapticManager.shared.impact(style: HapticManager.ImpactStyle.medium)
            }
        }
    }


}


// MARK: - Confetti View
// MARK: - Celebration Particles (Clean falling dots)
struct CelebrationParticlesView: View {
    @State private var particles: [CelebrationParticle] = []

    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .position(p.position)
                    .opacity(p.opacity)
            }
        }
        .ignoresSafeArea()
        .onAppear { startCelebration() }
    }

    func startCelebration() {
        #if canImport(UIKit)
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        #else
        let w: CGFloat = 400; let h: CGFloat = 800
        #endif

        let colors: [Color] = [
            Color(hex: "#ffd700").opacity(0.8),
            Color(hex: "#ffd700").opacity(0.5),
            .white.opacity(0.6),
            .white.opacity(0.3),
            Color(hex: "#7e57c2").opacity(0.5)
        ]

        particles = (0..<40).map { _ in
            CelebrationParticle(
                position: CGPoint(x: .random(in: 0...w), y: .random(in: -100 ... -20)),
                size: .random(in: 3...7),
                color: colors.randomElement() ?? .white,
                opacity: 1.0
            )
        }

        for i in particles.indices {
            let delay = Double.random(in: 0...0.8)
            let duration = Double.random(in: 1.2...2.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeIn(duration: duration)) {
                    particles[i].position.y = h + 50
                    particles[i].position.x += .random(in: -60...60)
                    particles[i].opacity = 0
                }
            }
        }
    }
}

struct CelebrationParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    var opacity: Double
}

#Preview {
    NameDetailView(name: Name.sample, viewModel: NamesViewModel())
}

// MARK: - Activity View Controller
#if canImport(UIKit)
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
#endif
