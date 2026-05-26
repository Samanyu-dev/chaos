import SwiftUI

struct AnimatedGradientBackground: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var animateBlob1 = false
    @State private var animateBlob2 = false
    @State private var animateBlob3 = false
    
    var body: some View {
        ZStack {
            // Base background color
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            // Animating mesh blobs
            GeometryReader { geo in
                let speed = themeManager.currentTheme.animationSpeedMultiplier
                
                ZStack {
                    // Blob 1: Primary Accent color
                    Circle()
                        .fill(themeManager.currentTheme.primaryAccent)
                        .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                        .opacity(0.18)
                        .blur(radius: 80)
                        .offset(
                            x: animateBlob1 ? geo.size.width * 0.3 : -geo.size.width * 0.2,
                            y: animateBlob1 ? geo.size.height * 0.1 : geo.size.height * 0.5
                        )
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 9.0 / speed)
                                .repeatForever(autoreverses: true)
                            ) {
                                animateBlob1.toggle()
                            }
                        }
                    
                    // Blob 2: Secondary Accent color
                    Circle()
                        .fill(themeManager.currentTheme.secondaryAccent)
                        .frame(width: geo.size.width * 1.1, height: geo.size.width * 1.1)
                        .opacity(0.15)
                        .blur(radius: 95)
                        .offset(
                            x: animateBlob2 ? -geo.size.width * 0.2 : geo.size.width * 0.4,
                            y: animateBlob2 ? geo.size.height * 0.6 : -geo.size.height * 0.1
                        )
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 12.0 / speed)
                                .repeatForever(autoreverses: true)
                            ) {
                                animateBlob2.toggle()
                            }
                        }
                    
                    // Blob 3: Warm/Ambient Glow
                    Circle()
                        .fill(themeManager.currentTheme.ambientGlow)
                        .frame(width: geo.size.width * 0.7, height: geo.size.width * 0.7)
                        .opacity(0.25)
                        .blur(radius: 70)
                        .offset(
                            x: animateBlob3 ? geo.size.width * 0.1 : -geo.size.width * 0.3,
                            y: animateBlob3 ? -geo.size.height * 0.2 : geo.size.height * 0.3
                        )
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 7.0 / speed)
                                .repeatForever(autoreverses: true)
                            ) {
                                animateBlob3.toggle()
                            }
                        }
                }
            }
            .ignoresSafeArea()
            
            // Grain or grid overlay pattern to make it premium (Nothing OS + spatial visual aesthetics)
            GridPatternOverlay()
                .opacity(0.04)
                .ignoresSafeArea()
        }
    }
}

struct GridPatternOverlay: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 30
            var x: CGFloat = 0
            while x < size.width {
                context.stroke(
                    Path(CGRect(x: x, y: 0, width: 0.5, height: size.height)),
                    with: .color(.white),
                    lineWidth: 0.5
                )
                x += step
            }
            
            var y: CGFloat = 0
            while y < size.height {
                context.stroke(
                    Path(CGRect(x: 0, y: y, width: size.width, height: 0.5)),
                    with: .color(.white),
                    lineWidth: 0.5
                )
                y += step
            }
        }
    }
}
