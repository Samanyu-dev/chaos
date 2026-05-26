import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    // Spatial Canvas States
    @State private var canvasOffset = CGSize.zero
    @State private var selectedTripIndex = 0
    @State private var isDetailPortalExpanded = false
    @State private var orbitAngle: Double = 0.0
    @State private var selectedFriend: User? = nil
    @State private var showFriendPopup = false
    @State private var animateUniverse = false
    
    // Parallax interactive rotation based on tilt
    @State private var canvasTilt = CGSize.zero
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Spatial Starfield & Mesh Galaxy Background
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // Spatial Interactive Universe Canvas
            GeometryReader { geo in
                ZStack {
                    // Cosmic Orbiting Circles for focused trip
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.currentTheme.primaryAccent.opacity(0.18),
                                    themeManager.currentTheme.secondaryAccent.opacity(0.04),
                                    .clear
                                ],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-orbitAngle * 0.5))
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.currentTheme.secondaryAccent.opacity(0.12),
                                    themeManager.currentTheme.primaryAccent.opacity(0.02),
                                    .clear
                                ],
                                startPoint: .leading, endPoint: .trailing
                            ),
                            lineWidth: 1.0
                        )
                        .frame(width: 380, height: 380)
                        .rotationEffect(.degrees(orbitAngle * 0.3))
                    
                    // FLOATING BACKGROUND TRIP WORLD (Non-focused trip)
                    let inactiveIndex = selectedTripIndex == 0 ? 1 : 0
                    let inactiveTrip = appViewModel.trips[inactiveIndex]
                    
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            inactiveTrip.bannerColors[0].opacity(0.45),
                                            inactiveTrip.bannerColors[1].opacity(0.15),
                                            .clear
                                        ],
                                        center: .center, startRadius: 0, endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: 2)
                                .shadow(color: inactiveTrip.bannerColors[0].opacity(0.3), radius: 10)
                            
                            Text("☁️")
                                .font(.system(size: 20))
                                .offset(x: -25, y: -25)
                        }
                        
                        Text(inactiveTrip.title)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .scaleEffect(0.7)
                    .opacity(0.55)
                    .blur(radius: 1)
                    .position(x: geo.size.width * 0.8 + canvasOffset.width, y: geo.size.height * 0.25 + canvasOffset.height)
                    .onTapGesture {
                        swapFocusedTripWorld(to: inactiveIndex)
                    }
                    
                    // CENTER FOCUS TRIP WORLD (The Active Trip Planet)
                    let activeTrip = appViewModel.trips[selectedTripIndex]
                    
                    VStack(spacing: 12) {
                        ZStack {
                            // Atmospheric outer aura
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            activeTrip.bannerColors[0].opacity(0.5),
                                            activeTrip.bannerColors[1].opacity(0.18),
                                            .clear
                                        ],
                                        center: .center, startRadius: 0, endRadius: 90
                                    )
                                )
                                .frame(width: 180, height: 180)
                                .scaleEffect(animateUniverse ? 1.08 : 0.95)
                                .blur(radius: 4)
                            
                            // Glowing planetary body
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: activeTrip.bannerColors,
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 130, height: 130)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: activeTrip.bannerColors[0].opacity(0.5), radius: 25)
                            
                            // Atmospheric floating icons
                            Text("☀️")
                                .font(.system(size: 24))
                                .offset(x: -45, y: -45)
                                .rotationEffect(.degrees(-orbitAngle * 0.2))
                            
                            // Countdown badge overlay
                            VStack(spacing: 0) {
                                Text("\(activeTrip.daysLeft)")
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                Text("DAYS")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        VStack(spacing: 2) {
                            Text(activeTrip.title)
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: activeTrip.bannerColors[0].opacity(0.5), radius: 8)
                            
                            Text(activeTrip.subtitle)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                    }
                    .position(x: geo.size.width / 2 + canvasOffset.width, y: geo.size.height * 0.45 + canvasOffset.height)
                    .rotation3DEffect(.degrees(Double(canvasTilt.width * 0.15)), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(Double(canvasTilt.height * 0.15)), axis: (x: 1, y: 0, z: 0))
                    
                    // ORBITING FRIENDS NODES (Friend circles physically revolving around the active world!)
                    ForEach(Array(activeTrip.friends.enumerated()), id: \.offset) { index, friend in
                        let radius: Double = 145.0
                        let offsetPhase = Double(index) * (360.0 / Double(activeTrip.friends.count))
                        let angleInRadians = (orbitAngle + offsetPhase) * Double.pi / 180.0
                        
                        let fx = geo.size.width / 2 + canvasOffset.width + CGFloat(cos(angleInRadians) * radius)
                        let fy = geo.size.height * 0.45 + canvasOffset.height + CGFloat(sin(angleInRadians) * radius)
                        
                        Button(action: {
                            SoundManager.shared.playOrbSound()
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                                selectedFriend = friend
                                showFriendPopup = true
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(activeTrip.bannerColors[0], lineWidth: 2)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: activeTrip.bannerColors[0], radius: 6)
                                
                                Circle()
                                    .fill(themeManager.currentTheme.cardBackground)
                                    .frame(width: 40, height: 40)
                                
                                Text(friend.avatar)
                                    .font(.system(size: 20))
                                
                                // Orbiting active emoji signal indicator
                                Text(friend.activeEmoji)
                                    .font(.system(size: 11))
                                    .background(Circle().fill(Color.black).frame(width: 16, height: 16))
                                    .offset(x: 14, y: 14)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: fx, y: fy)
                    }
                    
                    // LAYERED MEMORIES CLUSTER (Visual photo nodes floating at peripheral depths)
                    ForEach(0..<2) { i in
                        let memory = appViewModel.memories[i]
                        let offset = getMemoryClusterOffset(i, geo: geo)
                        
                        GlassCard(cornerRadius: 16, fillOpacity: 0.15) {
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(colors: memory.gradientColors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: 60, height: 60)
                                
                                Text(memory.senderAvatar + " " + memory.title.split(separator: " ").first!)
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80)
                        .scaleEffect(0.65)
                        .opacity(0.45)
                        .blur(radius: 0.5)
                        .position(x: offset.x + canvasOffset.width, y: offset.y + canvasOffset.height)
                        .onTapGesture {
                            SoundManager.shared.playClick()
                            withAnimation {
                                appViewModel.activeTab = .memories
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { val in
                            canvasOffset = val.translation
                            canvasTilt = val.translation
                        }
                        .onEnded { val in
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.76)) {
                                canvasOffset = .zero
                                canvasTilt = .zero
                            }
                        }
                )
            }
            .ignoresSafeArea()
            
            // HEADS-UP GRAPHIC OVERLAYS (Dynamic Island & Lock Widgets resting elegantly at top)
            VStack {
                // Centered Dynamic Island mockup
                DynamicIslandMockup()
                    .padding(.top, 10)
                
                Spacer()
                
                // BOTTOM GLASS TRIP CONTROL PANEL (Swipe up to expand itinerary timeline!)
                VStack(spacing: 8) {
                    // Pull indicator bar
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TRIP SYSTEM DIRECTORY")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            let activeTrip = appViewModel.trips[selectedTripIndex]
                            Text(activeTrip.title)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        // Budget stats inside panel
                        let activeTrip = appViewModel.trips[selectedTripIndex]
                        Text("Shared pot: $\(Int(activeTrip.cost))")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(themeManager.currentTheme.primaryAccent.opacity(0.15))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    
                    if isDetailPortalExpanded {
                        // Expandable itinerary events list
                        VStack(alignment: .leading, spacing: 14) {
                            Divider().background(Color.white.opacity(0.12))
                            
                            HStack {
                                Label("WEATHER FORECAST", systemImage: "cloud.sun.fill")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                Spacer()
                                Text("28°C • Clear Skies")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            
                            Text("Timeline Timeline Agenda:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                                .padding(.horizontal, 8)
                            
                            let activeTrip = appViewModel.trips[selectedTripIndex]
                            ForEach(activeTrip.upcomingEvents) { event in
                                TimelineItemRow(event: event)
                                    .padding(.horizontal, 8)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(themeManager.currentTheme.cardBackground)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .background(.ultraThinMaterial)
                )
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.5), radius: 25, y: -5)
                .padding(.horizontal, 16)
                .padding(.bottom, 110)
                .onTapGesture {
                    SoundManager.shared.playClick()
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isDetailPortalExpanded.toggle()
                    }
                }
            }
            
            // Orbiting Friend Details popup drawer
            if showFriendPopup, let friend = selectedFriend {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showFriendPopup = false
                                selectedFriend = nil
                            }
                        }
                    
                    VStack {
                        Spacer()
                        
                        GlassCard(cornerRadius: 24, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Text(friend.avatar)
                                        .font(.system(size: 34))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(friend.name)
                                            .font(.system(.headline, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Text(friend.username)
                                            .font(.system(size: 11))
                                            .foregroundColor(themeManager.currentTheme.secondaryText)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            showFriendPopup = false
                                            selectedFriend = nil
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                }
                                
                                HStack(spacing: 6) {
                                    Text("Cosmic Status:")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                    
                                    Text(friend.status)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 220)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onReceive(timer) { _ in
            // increment orbiting coordinate offsets
            orbitAngle += 0.4
        }
        .onAppear {
            appViewModel.activeTripIndex = selectedTripIndex
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                animateUniverse = true
            }
        }
    }
    
    // SwapFocusedTripWorld animation transition
    private func swapFocusedTripWorld(to index: Int) {
        SoundManager.shared.playTransition()
        withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
            selectedTripIndex = index
            appViewModel.activeTripIndex = index
        }
    }
    
    private func getMemoryClusterOffset(_ index: Int, geo: GeometryProxy) -> CGPoint {
        if index == 0 {
            return CGPoint(x: geo.size.width * 0.15, y: geo.size.height * 0.25)
        } else {
            return CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.68)
        }
    }
}
