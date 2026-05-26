import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var pulseLogo = false
    @State private var particlesCount = 0
    @State private var revealLogo = false
    @State private var ringRotate = 0.0
    @State private var ambientGlow = 0.0
    
    var body: some View {
        ZStack {
            // Dark cinematic background
            Color(hex: "030308")
                .ignoresSafeArea()
            
            // Subtle mesh gradient ambient glow
            RadialGradient(
                colors: [
                    themeManager.currentTheme.primaryAccent.opacity(ambientGlow * 0.22),
                    themeManager.currentTheme.secondaryAccent.opacity(ambientGlow * 0.12),
                    .clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 280
            )
            .ignoresSafeArea()
            
            // Glowing starfield / particle system
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<20, id: \.self) { index in
                        Circle()
                            .fill(index % 2 == 0 ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent)
                            .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5))
                            .opacity(particlesCount > 0 ? Double.random(in: 0.3...0.8) : 0.0)
                            .blur(radius: 0.5)
                            .position(
                                x: CGFloat.random(in: 0...geo.size.width),
                                y: CGFloat.random(in: 0...geo.size.height)
                            )
                            .animation(
                                .easeInOut(duration: Double.random(in: 2.0...4.0))
                                .repeatForever(autoreverses: true),
                                value: particlesCount
                            )
                    }
                }
            }
            .ignoresSafeArea()
            
            // Orbiting Core rings + Logo Reveal
            VStack(spacing: 20) {
                ZStack {
                    // Outer glowing path
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [themeManager.currentTheme.primaryAccent, .clear, themeManager.currentTheme.secondaryAccent, .clear],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(ringRotate))
                    
                    // Core dynamic glowing orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    themeManager.currentTheme.primaryAccent,
                                    themeManager.currentTheme.secondaryAccent.opacity(0.4),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulseLogo ? 1.15 : 0.85)
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.6), radius: 25)
                    
                    // Floating micro satellite
                    Circle()
                        .fill(themeManager.currentTheme.primaryAccent)
                        .frame(width: 8, height: 8)
                        .offset(x: 70)
                        .rotationEffect(.degrees(-ringRotate * 1.5))
                        .shadow(color: themeManager.currentTheme.primaryAccent, radius: 4)
                }
                .opacity(revealLogo ? 1.0 : 0.0)
                .scaleEffect(revealLogo ? 1.0 : 0.6)
                
                // Cinematic Text Logo
                VStack(spacing: 6) {
                    Text("ORBIT")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .kerning(8)
                        .foregroundColor(.white)
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.5), radius: 10)
                    
                    Text("FRIENDSHIP OPERATING SYSTEM")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .kerning(4)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                .offset(y: revealLogo ? 0 : 30)
                .opacity(revealLogo ? 1.0 : 0.0)
            }
        }
        .onAppear {
            // Stage 1: Ambient light rises
            withAnimation(.easeIn(duration: 1.2)) {
                ambientGlow = 1.0
            }
            
            // Stage 2: Particles ignite
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                particlesCount = 20
            }
            
            // Stage 3: Ring rotational system launches & Logo reveals
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.95, dampingFraction: 0.72)) {
                    revealLogo = true
                }
                
                withAnimation(.linear(duration: 8.0).repeatForever(false)) {
                    ringRotate = 360
                }
                
                // Infinite rotation drive
                let baseAnimation = Animation.linear(duration: 7.0).repeatForever(autoreverses: false)
                withAnimation(baseAnimation) {
                    ringRotate = 360
                }
            }
            
            // Stage 4: Breathing Logo Pulse
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    pulseLogo = true
                }
            }
            
            // Stage 5: Autoshift transitions to Onboarding
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                appViewModel.completeSplash()
            }
        }
    }
}
