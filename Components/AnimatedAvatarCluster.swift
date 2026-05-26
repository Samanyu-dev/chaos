import SwiftUI

struct AnimatedAvatarCluster: View {
    var friends: [User]
    var size: CGFloat = 36
    var overlap: CGFloat = 12
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isGlowPulse = false
    
    var body: some View {
        HStack(spacing: -overlap) {
            ForEach(Array(friends.enumerated()), id: \.offset) { index, friend in
                ZStack {
                    // Avatar outline with pulse
                    Circle()
                        .stroke(
                            index == 0 ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent,
                            lineWidth: 2
                        )
                        .frame(width: size + 4, height: size + 4)
                        .shadow(
                            color: (index == 0 ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent)
                                .opacity(isGlowPulse ? 0.6 : 0.2),
                            radius: isGlowPulse ? 6 : 2
                        )
                    
                    // Glassy avatar background
                    Circle()
                        .fill(themeManager.currentTheme.cardBackground)
                        .frame(width: size, height: size)
                    
                    // Emoji / Symbol representation
                    Text(friend.avatar)
                        .font(.system(size: size * 0.55))
                    
                    // Small active indicators (green dot or active status emoji)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(friend.activeEmoji)
                                .font(.system(size: size * 0.38))
                                .background(Circle().fill(Color.black).frame(width: size * 0.45, height: size * 0.45))
                                .offset(x: 2, y: 2)
                        }
                    }
                    .frame(width: size, height: size)
                }
                .zIndex(Double(friends.count - index))
            }
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.8)
                .repeatForever(autoreverses: true)
            ) {
                isGlowPulse.toggle()
            }
        }
    }
}
