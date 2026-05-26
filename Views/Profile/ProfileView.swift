import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var animateStats = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                // Header Profile Card
                HStack(spacing: 16) {
                    // Glowing Profile avatar
                    ZStack {
                        Circle()
                            .fill(themeManager.currentTheme.primaryAccent.opacity(0.15))
                            .frame(width: 74, height: 74)
                        
                        Circle()
                            .stroke(themeManager.currentTheme.primaryAccent, lineWidth: 2)
                            .frame(width: 68, height: 68)
                            .shadow(color: themeManager.currentTheme.primaryAccent, radius: 8)
                        
                        Text(appViewModel.currentUser.avatar)
                            .font(.system(size: 38))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appViewModel.currentUser.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(appViewModel.currentUser.username)
                            .font(.system(size: 12))
                            .foregroundColor(themeManager.currentTheme.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // FRIENDSHIP OS DASHBOARD
                Text("Friendship OS World")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                    .padding(.horizontal, 20)
                
                // Streaks & Stats Grid
                HStack(spacing: 12) {
                    SocialStatsCard(
                        title: "Group Streaks",
                        val: "182d",
                        icon: "flame.fill",
                        subtitle: "Consecutive active days"
                    )
                    
                    SocialStatsCard(
                        title: "Inside Jokes",
                        val: "42",
                        icon: "quote.bubble.fill",
                        subtitle: "Recorded quotes & memes"
                    )
                }
                .padding(.horizontal, 20)
                
                // Collaborative bucket list node
                GlassCard(cornerRadius: 22, fillOpacity: 0.08) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("ACTIVE BUCKET LIST", systemImage: "list.bullet.rectangle.fill")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            Spacer()
                        }
                        
                        VStack(spacing: 10) {
                            BucketListItem(label: "DJ in Shibuya concrete basement", checked: true)
                            BucketListItem(label: "Rent drift quad-bikes in Vik", checked: false)
                            BucketListItem(label: "Spin street food wheel 10 times", checked: false)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // COLLABORATIVE MUSIC WIDGET
                GlassCard(cornerRadius: 20, fillOpacity: 0.1) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.currentTheme.secondaryAccent.opacity(0.2))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "music.note")
                                .font(.title3)
                                .foregroundColor(themeManager.currentTheme.secondaryAccent)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Shibuya Alley Vibe")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Group Spotify Playlist • 48 Songs")
                                .font(.system(size: 10))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                
                // MULTI-THEME SELECTOR DECK
                Text("App Visual Themes")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 10) {
                    ForEach(OrbitTheme.allCases) { theme in
                        Button(action: {
                            themeManager.setTheme(theme)
                            
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }) {
                            HStack {
                                Circle()
                                    .fill(theme.primaryAccent)
                                    .frame(width: 14, height: 14)
                                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                
                                Text(theme.rawValue)
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if themeManager.currentTheme == theme {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                        .font(.title3)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(themeManager.currentTheme == theme ? .white.opacity(0.08) : .white.opacity(0.02))
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        themeManager.currentTheme == theme ? themeManager.currentTheme.primaryAccent.opacity(0.4) : Color.clear,
                                        lineWidth: 1
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                // SETTINGS / ACCOUNT CONTROLS
                Divider().background(Color.white.opacity(0.1)).padding(.horizontal, 20)
                
                Button(action: {
                    appViewModel.logOut()
                }) {
                    HStack {
                        Image(systemName: "power")
                            .font(.system(size: 16, weight: .bold))
                        Text("Log Out from Orbit")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(hex: "ff006e"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "ff006e").opacity(0.1))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "ff006e").opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                    .frame(height: 120)
            }
        }
    }
}

struct BucketListItem: View {
    var label: String
    var checked: Bool
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(checked ? themeManager.currentTheme.primaryAccent : Color.white.opacity(0.3))
                .font(.system(size: 16, weight: .semibold))
            
            Text(label)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(checked ? .white : Color.white.opacity(0.6))
                .strikethrough(checked)
            Spacer()
        }
    }
}
