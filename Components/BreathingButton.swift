import SwiftUI

struct BreathingButton: View {
    var title: String
    var icon: String? = nil
    var isGlowing: Bool = true
    var action: () -> Void
    
    @State private var isBreathing = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .bold))
                }
                
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(themeManager.currentTheme.accentGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .shadow(
                color: isGlowing ? themeManager.currentTheme.primaryAccent.opacity(0.4) : Color.clear,
                radius: isBreathing ? 16 : 8,
                x: 0,
                y: isBreathing ? 4 : 2
            )
            .scaleEffect(isBreathing ? 1.02 : 0.98)
        }
        .buttonStyle(HapticButtonStyle())
        .onAppear {
            if isGlowing {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isBreathing.toggle()
                }
            }
        }
    }
}

// Haptic feedback button style
struct HapticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    triggerHaptic()
                }
            }
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
