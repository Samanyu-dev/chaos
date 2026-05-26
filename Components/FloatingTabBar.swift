import SwiftUI

struct FloatingTabBar: View {
    @Binding var activeTab: ActiveTab
    @EnvironmentObject var themeManager: ThemeManager
    
    // Tab definitions
    let tabs: [(ActiveTab, String, String)] = [
        (.home, "Home", "safari.fill"),
        (.map, "Map", "map.fill"),
        (.memories, "Memories", "photo.stack.fill"),
        (.chaos, "Chaos", "sparkles"),
        (.profile, "Profile", "person.2.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.0.rawValue) { tab, label, icon in
                let isActive = activeTab == tab
                
                Button(action: {
                    SoundManager.shared.playClick()
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        activeTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if isActive {
                                // Morphing active background halo
                                Circle()
                                    .fill(themeManager.currentTheme.accentGradient)
                                    .frame(width: 44, height: 44)
                                    .opacity(0.18)
                                    .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 10)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            Image(systemName: icon)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(isActive ? themeManager.currentTheme.primaryAccent : Color.white.opacity(0.45))
                                .scaleEffect(isActive ? 1.2 : 1.0)
                        }
                        
                        Text(label)
                            .font(.system(size: 10, weight: isActive ? .bold : .medium, design: .rounded))
                            .foregroundColor(isActive ? themeManager.currentTheme.primaryText : Color.white.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        // High fidelity glass backdrop
        .background(
            Capsule()
                .fill(themeManager.currentTheme.cardBackground)
                .background(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.2),
                                    .white.opacity(0.04),
                                    themeManager.currentTheme.primaryAccent.opacity(0.3),
                                    .white.opacity(0.04)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .background(.ultraThinMaterial)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}
