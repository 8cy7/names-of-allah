//
//  ShareHelper.swift
//  NamesOfAllah
//
//  Share functionality for names
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum ShareType {
    case text
    case squareImage
    case storyImage
}

class ShareHelper {

    // MARK: - Share Text
    static func shareText(name: Name) -> String {
        let rtl = "\u{200F}" // Right-to-Left mark
        var text = """
        \(rtl)🌟 \(name.nameArabic) 🌟
        \(rtl)\(name.translation)

        \(rtl)📖 المعنى:
        \(rtl)\(name.meaning)

        \(rtl)🌱 كيف تعيش هذا الاسم:
        """

        if !name.liveIt.isEmpty {
            let summary = name.liveIt.prefix(2).map { "\(rtl)• \($0)" }.joined(separator: "\n")
            text += "\n\(summary)"
        }

        if !name.story.isEmpty {
            text += """


            \(rtl)📚 القصة:
            \(rtl)\(name.story)
            """
        }

        text += "\n\n\(rtl)🤲 من تطبيق أسماء الله - تعلّم وتدبّر"
        text += "\n\(rtl)📲 https://apps.apple.com/app/id6761344902"

        return text
    }

    // MARK: - Generate UIImage from SwiftUI View
    @MainActor
    static func generateImage(from view: some View, size: CGSize, scale: CGFloat = 3.0) -> UIImage? {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = scale
        return renderer.uiImage
    }

    // MARK: - Present Share Sheet
    static func presentShareSheet(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }

        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        rootVC.present(activityVC, animated: true)
    }
}

// MARK: - Square Image Share View (1:1)
struct SquareShareView: View {
    let name: Name

    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0B0F1A")

            // Glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#7e57c2").opacity(0.15), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)

            // Corner accents
            CornerAccents()

            // Content
            VStack(spacing: 0) {
                // Number
                Text("\(name.id.arabicDigits) / ٩٩")
                    .font(.custom("IBMPlexSansArabic-Bold", size: 28))
                    .foregroundColor(Color(hex: "#ffd700").opacity(0.5))
                    .tracking(4)
                    .padding(.bottom, 24)

                // Arabic Name
                Text(name.nameArabic)
                    .font(.custom("DiwanMishafi", size: 150))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: 950)
                    .padding(.bottom, 12)

                // Translation
                Text(name.translation)
                    .font(.custom("IBMPlexSansArabic-SemiBold", size: 34))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 30)

                // Separator
                Rectangle()
                    .fill(Color(hex: "#ffd700").opacity(0.3))
                    .frame(width: 50, height: 1)
                    .padding(.bottom, 30)

                // Meaning
                Text(name.meaning)
                    .font(.custom("IBMPlexSansArabic-Regular", size: 32))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineSpacing(14)
                    .frame(maxWidth: 850)
                    .lineLimit(4)
            }

            // Branding
            VStack {
                Spacer()
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color(hex: "#ffd700").opacity(0.4))
                        .frame(width: 4, height: 4)
                    Text("أسماء الله الحسنى")
                        .font(.custom("IBMPlexSansArabic-SemiBold", size: 16))
                        .foregroundColor(.white.opacity(0.25))
                    Circle()
                        .fill(Color(hex: "#ffd700").opacity(0.4))
                        .frame(width: 4, height: 4)
                }
                .padding(.bottom, 45)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Story Image Share View (9:16)
struct StoryShareView: View {
    let name: Name

    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0B0F1A")

            // Top glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#7e57c2").opacity(0.12), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 350
                    )
                )
                .frame(width: 700, height: 700)
                .offset(y: -500)

            // Bottom glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#ffd700").opacity(0.06), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(y: 700)

            // Corner accents
            CornerAccents()

            // Content
            VStack(spacing: 0) {
                // Number
                Text("\(name.id.arabicDigits) / ٩٩")
                    .font(.custom("IBMPlexSansArabic-Bold", size: 26))
                    .foregroundColor(Color(hex: "#ffd700").opacity(0.4))
                    .tracking(6)
                    .padding(.top, 100)
                    .padding(.bottom, 35)

                // Arabic Name
                Text(name.nameArabic)
                    .font(.custom("DiwanMishafi", size: 140))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .frame(maxWidth: 950)
                    .padding(.bottom, 14)

                // Separator
                Rectangle()
                    .fill(Color(hex: "#ffd700").opacity(0.25))
                    .frame(width: 60, height: 1)
                    .padding(.bottom, 25)

                // Evidence
                if !name.evidence.isEmpty {
                    Text(name.evidence)
                        .font(.custom("IBMPlexSansArabic-Regular", size: 26))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .frame(maxWidth: 900)
                        .lineLimit(3)
                        .padding(.horizontal, 70)
                        .padding(.bottom, 35)
                }

                // Meaning Section
                StoryRTLSection(title: "المعنى", content: name.meaning, maxLines: 4)
                    .padding(.bottom, 25)

                // Story Section
                if !name.story.isEmpty {
                    StoryRTLSection(title: "قصة", content: name.story, maxLines: 6)
                        .padding(.bottom, 25)
                }

                // How to Live Section
                if !name.liveIt.isEmpty {
                    VStack(alignment: .trailing, spacing: 14) {
                        // Header — RTL: text first, bar after
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Text("كيف تعيش هذا الاسم")
                                .font(.custom("IBMPlexSansArabic-Bold", size: 26))
                                .foregroundColor(Color(hex: "#ffd700").opacity(0.6))
                                .padding(.trailing, 12)
                            Rectangle()
                                .fill(Color(hex: "#ffd700").opacity(0.4))
                                .frame(width: 2, height: 24)
                        }

                        // Items — bullet on right side
                        VStack(alignment: .trailing, spacing: 14) {
                            ForEach(Array(name.liveIt.prefix(3).enumerated()), id: \.offset) { _, item in
                                HStack(alignment: .top, spacing: 0) {
                                    Spacer(minLength: 0)
                                    Text(item)
                                        .font(.custom("IBMPlexSansArabic-Regular", size: 24))
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.trailing)
                                        .lineSpacing(6)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.trailing, 12)
                                    Circle()
                                        .fill(Color(hex: "#ffd700").opacity(0.4))
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 70)
                }

                Spacer()
            }

            // Footer
            VStack {
                Spacer()
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color(hex: "#ffd700").opacity(0.3))
                        .frame(width: 3, height: 3)
                    Text("أسماء الله الحسنى")
                        .font(.custom("IBMPlexSansArabic-SemiBold", size: 16))
                        .foregroundColor(.white.opacity(0.2))
                    Circle()
                        .fill(Color(hex: "#ffd700").opacity(0.3))
                        .frame(width: 3, height: 3)
                }
                .padding(.bottom, 55)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Story Section Component (RTL forced for ImageRenderer)
struct StoryRTLSection: View {
    let title: String
    let content: String
    var maxLines: Int = 5

    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            // Title with gold bar — RTL: text first, bar after (visually bar on right)
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Text(title)
                    .font(.custom("IBMPlexSansArabic-Bold", size: 26))
                    .foregroundColor(Color(hex: "#ffd700").opacity(0.6))
                    .padding(.trailing, 12)
                Rectangle()
                    .fill(Color(hex: "#ffd700").opacity(0.4))
                    .frame(width: 2, height: 24)
            }

            // Content text — right aligned
            Text(content)
                .font(.custom("IBMPlexSansArabic-Regular", size: 26))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.trailing)
                .lineSpacing(10)
                .lineLimit(maxLines)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 70)
    }
}

// Keep old name for compatibility
struct StorySectionView: View {
    let title: String
    let content: String
    var body: some View { StoryRTLSection(title: title, content: content) }
}

// MARK: - Corner Accents
struct CornerAccents: View {
    var body: some View {
        ZStack {
            // Top-left
            VStack {
                HStack {
                    CornerShape()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .padding(.top, 35)
                        .padding(.leading, 35)
                    Spacer()
                }
                Spacer()
            }
            // Top-right
            VStack {
                HStack {
                    Spacer()
                    CornerShape()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .rotationEffect(.degrees(90))
                        .padding(.top, 35)
                        .padding(.trailing, 35)
                }
                Spacer()
            }
            // Bottom-left
            VStack {
                Spacer()
                HStack {
                    CornerShape()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .rotationEffect(.degrees(-90))
                        .padding(.bottom, 35)
                        .padding(.leading, 35)
                    Spacer()
                }
            }
            // Bottom-right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CornerShape()
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .rotationEffect(.degrees(180))
                        .padding(.bottom, 35)
                        .padding(.trailing, 35)
                }
            }
        }
    }
}

struct CornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}


