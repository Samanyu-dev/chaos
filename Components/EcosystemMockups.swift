import SwiftUI

// MARK: - DYNAMIC ISLAND MOCKUP
struct DynamicIslandMockup: View {
    @State private var isExpanded = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                isExpanded.toggle()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            HStack(spacing: 12) {
                if !isExpanded {
                    // Collapsed state
                    Image(systemName: "sparkles")
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .font(.system(size: 11, weight: .bold))
                    
                    Text("Chaos active in Tokyo")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Capsule()
                        .fill(themeManager.currentTheme.secondaryAccent)
                        .frame(width: 5, height: 5)
                } else {
                    // Expanded cinematic detail state
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label("ORBIT COORDINATOR", systemImage: "sparkles")
                                .font(.system(size: 8, weight: .black))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            Spacer()
                            Text("2m away")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        
                        Text("Kai is closing in on Shibuya Alley spot")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            Text("⚡️ Signal reaction:")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                            Text("🍜 Meetup requested")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, isExpanded ? 16 : 12)
            .padding(.vertical, isExpanded ? 14 : 8)
            .background(Color.black)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 0.8))
            .shadow(color: Color.black.opacity(0.6), radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - LOCK SCREEN LIVE ACTIVITY WIDGET
struct LiveActivityWidget: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GlassCard(cornerRadius: 22, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        Text("⚡️")
                            .font(.system(size: 12))
                        Text("ORBIT LIVE")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("ACTIVE TRIP")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                }
                
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shibuya Alley Crawl")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("3 friends active • Golden Gai routing")
                            .font(.system(size: 10))
                            .foregroundColor(themeManager.currentTheme.secondaryText)
                    }
                    Spacer()
                    
                    // Countdown circle widget
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 3)
                            .frame(width: 38, height: 38)
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(themeManager.currentTheme.accentGradient, lineWidth: 3)
                            .frame(width: 38, height: 38)
                            .rotationEffect(.degrees(-90))
                        
                        Text("4d")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
