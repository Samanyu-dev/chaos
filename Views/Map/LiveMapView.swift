import SwiftUI

struct LiveMapView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var scaleMap: CGFloat = 1.0
    @State private var selectedFriend: User? = nil
    @State private var showOverlayCard = false
    @State private var radarPulse = false
    @State private var mapDraggedOffset = CGSize.zero
    @State private var emittedEmojis: [FloatingEmojiParticle] = []
    
    var body: some View {
        ZStack {
            // Full screen glowing grid canvas (visual representation of a spatial Apple Maps)
            GeometryReader { geo in
                ZStack {
                    // Deep space layout base
                    themeManager.currentTheme.backgroundColor
                        .ignoresSafeArea()
                    
                    // Radar pulse background overlay
                    Circle()
                        .stroke(themeManager.currentTheme.primaryAccent.opacity(radarPulse ? 0.0 : 0.25), lineWidth: 2)
                        .frame(width: 450, height: 450)
                        .scaleEffect(radarPulse ? 1.6 : 0.1)
                        .position(x: geo.size.width / 2 + mapDraggedOffset.width, y: geo.size.height / 2 + mapDraggedOffset.height)
                    
                    Circle()
                        .stroke(themeManager.currentTheme.secondaryAccent.opacity(radarPulse ? 0.0 : 0.15), lineWidth: 1.5)
                        .frame(width: 650, height: 650)
                        .scaleEffect(radarPulse ? 1.4 : 0.1)
                        .position(x: geo.size.width / 2 + mapDraggedOffset.width, y: geo.size.height / 2 + mapDraggedOffset.height)
                    
                    // The Map mesh grid coordinates
                    GridPatternOverlay()
                        .stroke(Color.white.opacity(0.04), lineWidth: 0.5)
                        .scaleEffect(scaleMap)
                        .offset(mapDraggedOffset)
                    
                    // Simulated route vector connections between friends
                    Path { path in
                        let center = CGPoint(x: geo.size.width / 2 + mapDraggedOffset.width, y: geo.size.height / 2 + mapDraggedOffset.height)
                        path.move(to: center)
                        
                        for friend in appViewModel.friends {
                            let fx = center.x + CGFloat(friend.latOffset * 8000)
                            let fy = center.y + CGFloat(friend.lonOffset * 8000)
                            path.addLine(to: CGPoint(x: fx, y: fy))
                            path.move(to: center)
                        }
                    }
                    .stroke(
                        LinearGradient(
                            colors: [themeManager.currentTheme.primaryAccent.opacity(0.35), themeManager.currentTheme.secondaryAccent.opacity(0.15)],
                            startPoint: .top, endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])
                    )
                    
                    // User Pin (Center Node)
                    FriendMapMarker(user: appViewModel.currentUser, isMe: true) {
                        withAnimation(.spring()) {
                            selectedFriend = appViewModel.currentUser
                            showOverlayCard = true
                        }
                    }
                    .position(x: geo.size.width / 2 + mapDraggedOffset.width, y: geo.size.height / 2 + mapDraggedOffset.height)
                    
                    // Friend Pins orbiting around User
                    ForEach(appViewModel.friends) { friend in
                        let fx = geo.size.width / 2 + mapDraggedOffset.width + CGFloat(friend.latOffset * 8000)
                        let fy = geo.size.height / 2 + mapDraggedOffset.height + CGFloat(friend.lonOffset * 8000)
                        
                        FriendMapMarker(user: friend, isMe: false) {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                                selectedFriend = friend
                                showOverlayCard = true
                            }
                        }
                        .position(x: fx, y: fy)
                    }
                    
                    // Floating Emitted Emojis Particles
                    ForEach(emittedEmojis) { emoji in
                        Text(emoji.char)
                            .font(.system(size: emoji.size))
                            .position(emoji.position)
                            .opacity(emoji.opacity)
                            .scaleEffect(emoji.scale)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { val in
                            mapDraggedOffset = val.translation
                        }
                        .onEnded { val in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.78)) {
                                // keep or decelerate drag offsets
                            }
                        }
                )
            }
            .ignoresSafeArea()
            
            // Map Top Control Deck details
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SPATIAL MAP")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                        
                        Text("Live Friendship Hub")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Map Action quick tools (Pinch zoom indicators)
                    HStack(spacing: 10) {
                        Button(action: {
                            withAnimation(.spring()) {
                                scaleMap = min(scaleMap + 0.25, 2.0)
                            }
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                scaleMap = max(scaleMap - 0.25, 0.5)
                            }
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Bottom floating information overlay card
                if showOverlayCard, let selected = selectedFriend {
                    GlassCard(cornerRadius: 24, fillOpacity: 0.16, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                Text(selected.avatar)
                                    .font(.system(size: 34))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(selected.name)
                                        .font(.system(.headline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text(selected.username)
                                        .font(.system(size: 11))
                                        .foregroundColor(themeManager.currentTheme.secondaryText)
                                }
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showOverlayCard = false
                                        selectedFriend = nil
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Text("STATUS:")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                
                                Text(selected.status)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Interactive Map Reactions Deck
                            Divider().background(Color.white.opacity(0.1))
                            
                            HStack {
                                Text("Signal Reaction:")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    ForEach(["🔥", "⚡️", "🍜", "🍻", "🚗"], id: \.self) { emoji in
                                        Button(action: {
                                            emitReaction(emoji)
                                        }) {
                                            Text(emoji)
                                                .font(.title3)
                                                .padding(6)
                                                .background(.white.opacity(0.08))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 110)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: false)) {
                radarPulse = true
            }
        }
    }
    
    // Core custom interaction reaction particle emitter!
    private func emitReaction(_ character: String) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<6 {
            let p = FloatingEmojiParticle(
                char: character,
                position: CGPoint(x: screenWidth / 2, y: screenHeight * 0.75),
                scale: 0.1,
                opacity: 1.0,
                size: CGFloat.random(in: 20...36)
            )
            
            emittedEmojis.append(p)
            
            let idx = emittedEmojis.count - 1
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                emittedEmojis[idx].position = CGPoint(
                    x: screenWidth / 2 + CGFloat.random(in: -100...100),
                    y: screenHeight * 0.4 + CGFloat.random(in: -120...120)
                )
                emittedEmojis[idx].scale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 0.8)) {
                    if idx < emittedEmojis.count {
                        emittedEmojis[idx].opacity = 0.0
                    }
                }
            }
        }
    }
}

// Map Marker components with pulsing active haloes
struct FriendMapMarker: View {
    var user: User
    var isMe: Bool
    var action: () -> Void
    
    @State private var markerBreathing = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Glow Halo
                Circle()
                    .fill(isMe ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent)
                    .frame(width: 48, height: 48)
                    .opacity(markerBreathing ? 0.35 : 0.1)
                    .scaleEffect(markerBreathing ? 1.3 : 0.8)
                
                // Ring details
                Circle()
                    .stroke(isMe ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent, lineWidth: 2)
                    .frame(width: 36, height: 36)
                    .shadow(color: isMe ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryAccent, radius: 4)
                
                // Translucent Glass bubble
                Circle()
                    .fill(themeManager.currentTheme.cardBackground)
                    .frame(width: 32, height: 32)
                
                // Avatar character representation
                Text(user.avatar)
                    .font(.system(size: 16))
                
                // Location Trail overlay indicator bubble
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(user.activeEmoji)
                            .font(.system(size: 10))
                            .background(Circle().fill(Color.black).frame(width: 14, height: 14))
                            .offset(x: 4, y: 4)
                    }
                }
                .frame(width: 32, height: 32)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                markerBreathing.toggle()
            }
        }
    }
}

// Particle representation
struct FloatingEmojiParticle: Identifiable {
    var id = UUID()
    var char: String
    var position: CGPoint
    var scale: CGFloat
    var opacity: Double
    var size: CGFloat
}
