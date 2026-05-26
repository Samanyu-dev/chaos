import SwiftUI

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 24
    var borderOpacity: Double = 0.12
    var fillOpacity: Double = 0.08
    var hasGlow: Bool = false
    var glowColor: Color = .blue
    var content: () -> Content
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(themeManager.currentTheme.cardBackground)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(themeManager.currentTheme.backgroundColor.opacity(0.1))
                            .blur(radius: 4)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.18),
                                .white.opacity(0.02),
                                themeManager.currentTheme.primaryAccent.opacity(borderOpacity * 1.5),
                                .white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: hasGlow ? glowColor.opacity(0.3) : Color.black.opacity(0.4),
                radius: hasGlow ? 15 : 12,
                x: 0,
                y: hasGlow ? 4 : 8
            )
    }
}

// Visual Effect Backdrop Helper (represented using ultraThinMaterial)
struct GlassBackground: ViewModifier {
    var cornerRadius: CGFloat = 24
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func glassify(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(GlassBackground(cornerRadius: cornerRadius))
    }
}
