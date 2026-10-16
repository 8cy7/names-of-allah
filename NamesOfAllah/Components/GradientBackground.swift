//
//  GradientBackground.swift
//  NamesOfAllah
//
//  Beautiful animated gradient background
//

import SwiftUI

struct GradientBackground: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var animateGradient = false

    var body: some View {
        themeManager.currentTheme.gradient
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: themeManager.currentTheme)
    }
}

// Premium Gold Gradient
struct GradientBackground_Gold: View {
    @State private var rotate = false

    var body: some View {
        ZStack {
            // Deep purple base
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1a1a2e"),
                    Color(hex: "#16213e"),
                    Color(hex: "#0f3460")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Golden shimmer
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#f5af19").opacity(0.3),
                    Color(hex: "#f12711").opacity(0.1),
                    Color.clear
                ]),
                center: rotate ? .topLeading : .bottomTrailing,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
            .blendMode(.screen)
            .onAppear {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    rotate.toggle()
                }
            }
        }
    }
}

// Mystical Purple Gradient
struct GradientBackground_Mystical: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            // Base mystical gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#141e30"),
                    Color(hex: "#243b55"),
                    Color(hex: "#1e3c72")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Purple aurora effect
            EllipticalGradient(
                colors: [
                    Color(hex: "#a770ef").opacity(0.4),
                    Color(hex: "#cf8bf3").opacity(0.2),
                    Color.clear
                ],
                center: UnitPoint(x: 0.5, y: 0.3 + sin(phase) * 0.1),
                startRadiusFraction: 0,
                endRadiusFraction: 0.8
            )
            .ignoresSafeArea()
            .blendMode(.plusLighter)
            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
        }
    }
}

// Floating particles effect
struct FloatingParticles: View {
    let count: Int = 20
    @State private var particles: [Particle] = []

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .blur(radius: particle.blur)
                    .position(particle.position)
                    .animation(
                        .linear(duration: particle.duration)
                        .repeatForever(autoreverses: false),
                        value: particle.position
                    )
            }
        }
        .onAppear {
            generateParticles()
        }
    }

    func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        particles = (0..<count).map { i in
            Particle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.1...0.3),
                blur: CGFloat.random(in: 0.5...2),
                duration: Double.random(in: 3...8)
            )
        }
    }
}

struct Particle: Identifiable {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
    let duration: Double
}

// Islamic geometric pattern overlay
struct IslamicPatternOverlay: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<3) { i in
                    Image(systemName: "star.and.crescent.moon")
                        .font(.system(size: 120, weight: .ultraLight))
                        .foregroundColor(.white)
                        .opacity(0.03)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .offset(
                            x: geometry.size.width * (i == 0 ? 0.2 : i == 1 ? 0.8 : 0.5),
                            y: geometry.size.height * (i == 0 ? 0.3 : i == 1 ? 0.7 : 0.5)
                        )
                        .animation(
                            .linear(duration: 120)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 2),
                            value: animate
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}

// Subtle Floating Particles - Very gentle and non-intrusive
struct SubtleFloatingParticles: View {
    @State private var particles: [SubtleParticle] = []
    let particleCount = 15

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.white.opacity(particle.opacity))
                        .frame(width: particle.size, height: particle.size)
                        .blur(radius: particle.blur)
                        .position(particle.position)
                        .animation(
                            .easeInOut(duration: particle.duration)
                            .repeatForever(autoreverses: true),
                            value: particle.position
                        )
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
                animateParticles(in: geometry.size)
            }
        }
        .ignoresSafeArea()
    }

    func generateParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            SubtleParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 1...2.5),
                opacity: Double.random(in: 0.05...0.15),
                blur: CGFloat.random(in: 1...3),
                duration: Double.random(in: 8...15)
            )
        }
    }

    func animateParticles(in size: CGSize) {
        for index in particles.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) {
                withAnimation(
                    .easeInOut(duration: particles[index].duration)
                    .repeatForever(autoreverses: true)
                ) {
                    particles[index].position = CGPoint(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height)
                    )
                }
            }
        }
    }
}

struct SubtleParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
    let duration: Double
}

// Gentle Shimmer - Subtle wave effect
struct GentleShimmer: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gentle radial shimmer
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.08),
                        Color.white.opacity(0.02),
                        Color.clear
                    ]),
                    center: UnitPoint(
                        x: 0.5 + sin(phase) * 0.15,
                        y: 0.5 + cos(phase * 0.8) * 0.15
                    ),
                    startRadius: 50,
                    endRadius: geometry.size.width * 0.8
                )
                .blendMode(.plusLighter)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .linear(duration: 20)
                .repeatForever(autoreverses: false)
            ) {
                phase = .pi * 2
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        FloatingParticles()
        IslamicPatternOverlay()
    }
}
