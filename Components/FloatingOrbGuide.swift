import SwiftUI

struct FloatingOrbGuide: View {
    var text: String
    var showSpeechBubble: Bool = true
    
    @State private var isFloating = false
    @State private var isGlowBreathing = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if showSpeechBubble && !text.isEmpty {
                // Futuristic speech glass container
                Text(text)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.currentTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(BubbleShape())
                    .overlay(
                        BubbleShape()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
            }
            
            // Floating 3D Orb Graphic
            VStack {
                ZStack {
                    // Outer aura glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    themeManager.currentTheme.primaryAccent.opacity(0.5),
                                    themeManager.currentTheme.secondaryAccent.opacity(0.2),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 35
                            )
                        )
                        .frame(width: 70, height: 70)
                        .scaleEffect(isGlowBreathing ? 1.25 : 0.9)
                    
                    // Translucent metallic orb body
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.65),
                                    themeManager.currentTheme.primaryAccent.opacity(0.4),
                                    themeManager.currentTheme.secondaryAccent.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 10, x: 0, y: 4)
                    
                    // Holographic Orb Ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.currentTheme.primaryAccent,
                                    .clear,
                                    themeManager.currentTheme.secondaryAccent,
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 58, height: 58)
                        .rotationEffect(.degrees(isGlowBreathing ? 360 : 0))
                    
                    // Glowing cyan robotic eyes
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color(hex: "00f5d4"))
                            .frame(width: 6, height: 6)
                            .shadow(color: Color(hex: "00f5d4"), radius: 3)
                        Circle()
                            .fill(Color(hex: "00f5d4"))
                            .frame(width: 6, height: 6)
                            .shadow(color: Color(hex: "00f5d4"), radius: 3)
                    }
                    .offset(y: -2)
                }
                .offset(y: isFloating ? -6 : 6)
                .onTapGesture {
                    SoundManager.shared.playOrbSound()
                }
                .onAppear {
                    // Play initial welcoming companion sound chime
                    SoundManager.shared.playOrbSound()
                    
                    // Start soft floating animations
                    withAnimation(
                        .easeInOut(duration: 2.2)
                        .repeatForever(autoreverses: true)
                    ) {
                        isFloating.toggle()
                    }
                    
                    // Start glow rhythm animations
                    withAnimation(
                        .easeInOut(duration: 3.5)
                        .repeatForever(autoreverses: true)
                    ) {
                        isGlowBreathing.toggle()
                    }
                }
            }
        }
    }
}

// Custom Speech Bubble Shape with left/bottom notch
struct BubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 16
        
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        // Notch on bottom-right side connecting to Orb
        path.addLine(to: CGPoint(x: rect.minX + radius + 10, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + radius - 4, y: rect.maxY + 8)) // tail point
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY - 4))
        
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}
