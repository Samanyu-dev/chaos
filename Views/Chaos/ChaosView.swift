import SwiftUI

struct ChaosView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var spinDegree = 0.0
    @State private var isGlowBurst = false
    @State private var showVotingBlock = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                // Header Area
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SPONTANEOUS MACHINE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                        
                        Text("Chaos Mode")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Text("🔥 Active")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(themeManager.currentTheme.primaryAccent.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Explanatory prompt from Companion
                FloatingOrbGuide(text: "Unmapped nodes are extremely active. Spin the wheel to generate a spontaneous route!", showSpeechBubble: true)
                    .padding(.horizontal, 20)
                
                // GAMIFIED ROULETTE WHEEL
                ZStack {
                    // Outer Ring Glow Aura
                    Circle()
                        .fill(themeManager.currentTheme.primaryAccent.opacity(0.12))
                        .frame(width: 280, height: 280)
                        .scaleEffect(isGlowBurst ? 1.15 : 0.95)
                    
                    // Rotating Segment Grid
                    Circle()
                        .strokeBorder(themeManager.currentTheme.primaryAccent, lineWidth: 3)
                        .background(Circle().fill(.white.opacity(0.04)))
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(spinDegree))
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(isGlowBurst ? 0.6 : 0.2), radius: 15)
                    
                    // Grid spokes
                    ForEach(0..<8) { i in
                        Rectangle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 1.5, height: 250)
                            .rotationEffect(.degrees(Double(i) * 22.5 + spinDegree))
                    }
                    
                    // Orbiting Mood items
                    ForEach(0..<8) { i in
                        let emojis = ["🕹️", "🎤", "🧗‍♂️", "🍢", "🎸", "🚗", "🍜", "☕️"]
                        Text(emojis[i])
                            .font(.system(size: 28))
                            .offset(y: -100)
                            .rotationEffect(.degrees(Double(i) * 45.0 + spinDegree))
                    }
                    
                    // Neon Core Spin button
                    Button(action: {
                        triggerChaosSpin()
                    }) {
                        Circle()
                            .fill(themeManager.currentTheme.accentGradient)
                            .frame(width: 70, height: 70)
                            .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.8), radius: 15)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(spinDegree * 2))
                            )
                    }
                    .disabled(appViewModel.isChaosSpinning)
                }
                .padding(.top, 10)
                
                // Spinner Reveal Result Panel
                if appViewModel.isChaosSpinning {
                    VStack(spacing: 8) {
                        Text("Decryption Engine Spinning...")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: themeManager.currentTheme.primaryAccent))
                    }
                    .transition(.opacity)
                } else if let adventure = appViewModel.selectedChaosAdventure {
                    // Exploded Mystery Card Reveal!
                    GlassCard(cornerRadius: 26, fillOpacity: 0.14, hasGlow: true, glowColor: themeManager.currentTheme.secondaryAccent) {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                Text(adventure.locationEmoji)
                                    .font(.largeTitle)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("MYSTERY ADVENTURE UNLOCKED")
                                        .font(.system(size: 8, weight: .black))
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                    Text(adventure.title)
                                        .font(.system(.headline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text(adventure.subtitle)
                                        .font(.system(size: 11))
                                        .foregroundColor(themeManager.currentTheme.secondaryText)
                                }
                                Spacer()
                                
                                Text(adventure.mood)
                                    .font(.system(size: 9, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(themeManager.currentTheme.secondaryAccent.opacity(0.2))
                                    .cornerRadius(6)
                            }
                            
                            Text(adventure.recommendationDescription)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                                .lineSpacing(4)
                            
                            // Group voting coordination buttons
                            if showVotingBlock {
                                Divider().background(Color.white.opacity(0.1))
                                
                                HStack(spacing: 12) {
                                    Text("Group Vote:")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.secondaryText)
                                    Spacer()
                                    
                                    VoteButton(label: "Lock In", icon: "checkmark.circle.fill", activeColor: Color(hex: "00f5d4"))
                                    VoteButton(label: "Veto Spin", icon: "xmark.circle.fill", activeColor: Color(hex: "ff006e"))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                            showVotingBlock = true
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 120)
            }
        }
    }
    
    // Core spin wheel actions
    private func triggerChaosSpin() {
        // Initial spin hum
        SoundManager.shared.playTransition()
        
        withAnimation(.spring(response: 2.8, dampingFraction: 0.8)) {
            spinDegree += 1440.0 + Double.random(in: 45...360)
            isGlowBurst = true
        }
        
        appViewModel.spinChaosWheel()
        
        // Decelerating ticking sound simulation
        let tickIntervals: [Double] = [
            0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.36, 0.42, 0.48, 0.55, 0.62, 0.7, 0.78, 0.88, 0.98,
            1.1, 1.22, 1.35, 1.5, 1.66, 1.83, 2.01, 2.2, 2.4, 2.62, 2.85
        ]
        
        for delay in tickIntervals {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                SoundManager.shared.playTick()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                isGlowBurst = false
            }
            
            // Decryption victory chimes arpeggio & premium alert haptic
            SoundManager.shared.playSuccess()
        }
    }
}

struct VoteButton: View {
    var label: String
    var icon: String
    var activeColor: Color
    
    @State private var isVoted = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isVoted.toggle()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                Text(label)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(isVoted ? .black : .white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isVoted ? activeColor : .white.opacity(0.06))
            .cornerRadius(10)
        }
    }
}
