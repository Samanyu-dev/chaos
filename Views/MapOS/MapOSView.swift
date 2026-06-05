enum MemoryTabSegment: String, CaseIterable, Identifiable {
    case moments = "Moments"
    case expenses = "Expenses"
    var id: String { self.rawValue }
}

struct MapOSView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    // Core Map OS Camera & Pan Settings
    @State private var mapDraggedOffset = CGSize.zero
    @State private var mapScale: CGFloat = 1.0
    @State private var cameraTargetOffset = CGSize.zero
    
    // Interactive Animation Drives
    @State private var orbitAngle = 0.0
    @State private var radarPulse = false
    @State private var activePulseGlow = false
    
    // Layer Active Node Selections
    @State private var selectedFriend: User? = nil
    @State private var selectedMemory: Memory? = nil
    @State private var selectedAdventure: ChaosAdventure? = nil
    @State private var selectedJoke: InsideJoke? = nil
    @State private var selectedExpense: Expense? = nil
    @State private var memoryTabSegment: MemoryTabSegment = .moments
    
    // Popovers & Drawer Panels
    @State private var showFriendPopup = false
    @State private var showMemoryDrawer = false
    @State private var showChaosSpinner = false
    @State private var showJokePopup = false
    @State private var showThemeDrawer = false
    @State private var showExpensePopup = false
    @State private var isDetailDrawerExpanded = false
    
    // Floating emoji reaction particle collector
    @State private var emittedEmojis: [FloatingEmojiParticle] = []
    
    // Broadcast momento states
    @State private var showBroadcastDrawer = false
    @State private var broadcastTitle = ""
    @State private var broadcastCaption = ""
    
    // Expense split ledger states
    @State private var showExpenseDrawer = false
    @State private var expenseTitle = ""
    @State private var expenseAmount = ""
    @State private var expenseCategory = "General"
    
    // Continuous rotation drive
    let orbitTimer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Master Map OS Canvas Geometry
            GeometryReader { geo in
                let mapCenter = CGPoint(
                    x: geo.size.width / 2 + mapDraggedOffset.width + cameraTargetOffset.width,
                    y: geo.size.height / 2 + mapDraggedOffset.height + cameraTargetOffset.height
                )
                
                ZStack {
                    // Cosmic space backdrop
                    themeManager.currentTheme.backgroundColor
                        .ignoresSafeArea()
                    
                    // Radar pulses centered around Shibuya core
                    Circle()
                        .stroke(themeManager.currentTheme.primaryAccent.opacity(radarPulse ? 0.0 : 0.28), lineWidth: 2)
                        .frame(width: 480, height: 480)
                        .scaleEffect(radarPulse ? 1.65 : 0.1)
                        .position(mapCenter)
                    
                    Circle()
                        .stroke(themeManager.currentTheme.secondaryAccent.opacity(radarPulse ? 0.0 : 0.15), lineWidth: 1.5)
                        .frame(width: 680, height: 680)
                        .scaleEffect(radarPulse ? 1.45 : 0.1)
                        .position(mapCenter)
                    
                    // Grid Coordinate Matrix System (Spatial Nothing OS overlay)
                    GridPatternOverlay()
                        .stroke(Color.white.opacity(0.04), lineWidth: 0.5)
                        .scaleEffect(mapScale)
                        .offset(mapDraggedOffset)
                    
                    // Route connection vectors between active group members
                    if appViewModel.activeTab == .map || appViewModel.activeTab == .home {
                        Path { path in
                            path.move(to: mapCenter)
                            for friend in appViewModel.friends {
                                let fx = mapCenter.x + CGFloat(friend.latOffset * 8000)
                                let fy = mapCenter.y + CGFloat(friend.lonOffset * 8000)
                                path.addLine(to: CGPoint(x: fx, y: fy))
                                path.move(to: mapCenter)
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [themeManager.currentTheme.primaryAccent.opacity(0.4), themeManager.currentTheme.secondaryAccent.opacity(0.12)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                        )
                    }
                    
                    // ==========================================
                    // 1. OVERVIEW & COCKPIT LAYER ANCHORS (.home)
                    // ==========================================
                    if appViewModel.activeTab == .home {
                        let activeTrip = appViewModel.activeTrip
                        
                        // Focused Trip Planet World Node
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(RadialGradient(colors: [activeTrip.bannerColors[0].opacity(0.55), activeTrip.bannerColors[1].opacity(0.15), .clear], center: .center, startRadius: 0, endRadius: 80))
                                    .frame(width: 170, height: 170)
                                    .scaleEffect(activePulseGlow ? 1.08 : 0.95)
                                    .blur(radius: 2)
                                
                                Circle()
                                    .fill(LinearGradient(colors: activeTrip.bannerColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 120, height: 120)
                                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                                    .shadow(color: activeTrip.bannerColors[0].opacity(0.5), radius: 20)
                                
                                Text("☀️")
                                    .font(.system(size: 22))
                                    .offset(x: -40, y: -40)
                                    .rotationEffect(.degrees(-orbitAngle * 0.2))
                                
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
                        .position(mapCenter)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // ==========================================
                    // 2. LIVE TRACKER & FRIENDS LAYER ANCHORS (.map)
                    // ==========================================
                    if appViewModel.activeTab == .map {
                        // User core node
                        FriendMapMarker(user: appViewModel.currentUser, isMe: true) {
                            SoundManager.shared.playMapPulse()
                            withAnimation(.spring()) {
                                selectedFriend = appViewModel.currentUser
                                showFriendPopup = true
                            }
                        }
                        .position(mapCenter)
                        
                        // Active Friends coordinate markers
                        ForEach(appViewModel.friends) { friend in
                            let fx = mapCenter.x + CGFloat(friend.latOffset * 8000)
                            let fy = mapCenter.y + CGFloat(friend.lonOffset * 8000)
                            
                            FriendMapMarker(user: friend, isMe: false) {
                                SoundManager.shared.playMapPulse()
                                withAnimation(.spring()) {
                                    selectedFriend = friend
                                    showFriendPopup = true
                                }
                            }
                            .position(x: fx, y: fy)
                        }
                    }
                    
                    // ==========================================
                    // 3. PARALLEL TIMELINE & MEMORIES LAYER ANCHORS (.memories)
                    // ==========================================
                    if appViewModel.activeTab == .memories {
                        if memoryTabSegment == .moments {
                            ForEach(appViewModel.memories) { memory in
                                let mx = mapCenter.x + CGFloat(memory.latOffset * 8000)
                                let my = mapCenter.y + CGFloat(memory.lonOffset * 8000)
                                
                                // Visual Glowing Photo Node Pinned on Spot
                                Button(action: {
                                    SoundManager.shared.playMapPulse()
                                    panCameraTo(x: -CGFloat(memory.latOffset * 8000), y: -CGFloat(memory.lonOffset * 8000))
                                    withAnimation(.spring(response: 0.48, dampingFraction: 0.76)) {
                                        selectedMemory = memory
                                        showMemoryDrawer = true
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .stroke(memory.gradientColors[0], lineWidth: 2)
                                            .frame(width: 46, height: 46)
                                            .shadow(color: memory.gradientColors[0], radius: 8)
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(LinearGradient(colors: memory.gradientColors, startPoint: .top, endPoint: .bottom))
                                            .frame(width: 36, height: 36)
                                            .rotationEffect(.degrees(15))
                                        
                                        Text(memory.senderAvatar)
                                            .font(.system(size: 16))
                                    }
                                }
                                .position(x: mx, y: my)
                            }
                        } else {
                            ForEach(appViewModel.expenses) { expense in
                                let ex = mapCenter.x + CGFloat(expense.latOffset * 8000)
                                let ey = mapCenter.y + CGFloat(expense.lonOffset * 8000)
                                
                                // Visual Glowing Expense Node Pinned on Spot
                                Button(action: {
                                    SoundManager.shared.playMapPulse()
                                    panCameraTo(x: -CGFloat(expense.latOffset * 8000), y: -CGFloat(expense.lonOffset * 8000))
                                    withAnimation(.spring(response: 0.48, dampingFraction: 0.76)) {
                                        selectedExpense = expense
                                        showExpensePopup = true
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .stroke(themeManager.currentTheme.primaryAccent, lineWidth: 2)
                                            .frame(width: 46, height: 46)
                                            .shadow(color: themeManager.currentTheme.primaryAccent, radius: 8)
                                        
                                        Circle()
                                            .fill(themeManager.currentTheme.accentGradient)
                                            .frame(width: 36, height: 36)
                                        
                                        Text("💸")
                                            .font(.system(size: 16))
                                    }
                                }
                                .position(x: ex, y: ey)
                            }
                        }
                    }
                    
                    // ==========================================
                    // 4. SPONTANEOUS ADVENTURES & CHAOS LAYER (.chaos)
                    // ==========================================
                    if appViewModel.activeTab == .chaos {
                        ForEach(appViewModel.chaosOptions) { adventure in
                            let ax = mapCenter.x + CGFloat(adventure.latOffset * 8000)
                            let ay = mapCenter.y + CGFloat(adventure.lonOffset * 8000)
                            
                            // Flashing Cosmic Anomaly Pin
                            Button(action: {
                                SoundManager.shared.playMapPulse()
                                panCameraTo(x: -CGFloat(adventure.latOffset * 8000), y: -CGFloat(adventure.lonOffset * 8000))
                                withAnimation(.spring(response: 0.48, dampingFraction: 0.76)) {
                                    selectedAdventure = adventure
                                    showChaosSpinner = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(themeManager.currentTheme.secondaryAccent.opacity(0.15))
                                        .frame(width: 60, height: 60)
                                        .scaleEffect(activePulseGlow ? 1.2 : 0.85)
                                    
                                    Circle()
                                        .stroke(themeManager.currentTheme.primaryAccent, lineWidth: 1.5)
                                        .frame(width: 44, height: 44)
                                        .shadow(color: themeManager.currentTheme.primaryAccent, radius: 10)
                                    
                                    Text(adventure.locationEmoji)
                                        .font(.system(size: 20))
                                }
                            }
                            .position(x: ax, y: ay)
                        }
                    }
                    
                    // ==========================================
                    // 5. FRIENDSHIP OS PROFILE & JOKE LAYER (.profile)
                    // ==========================================
                    if appViewModel.activeTab == .profile {
                        // Central planetary core representing Group friendship strength
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(themeManager.currentTheme.accentGradient.opacity(0.2))
                                    .frame(width: 140, height: 140)
                                    .scaleEffect(activePulseGlow ? 1.05 : 0.95)
                                
                                Circle()
                                    .stroke(themeManager.currentTheme.primaryAccent, lineWidth: 2)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: themeManager.currentTheme.primaryAccent, radius: 12)
                                
                                Text("🤝")
                                    .font(.system(size: 40))
                            }
                            
                            Text("Friendship Core Active")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .position(mapCenter)
                        .onTapGesture {
                            SoundManager.shared.playClick()
                            withAnimation(.spring()) {
                                showThemeDrawer = true
                            }
                        }
                        
                        // Localized Pinned Inside Jokes nodes
                        ForEach(MockData.jokes) { joke in
                            let jx = mapCenter.x + CGFloat(joke.latOffset * 8000)
                            let jy = mapCenter.y + CGFloat(joke.lonOffset * 8000)
                            
                            Button(action: {
                                SoundManager.shared.playOrbSound()
                                panCameraTo(x: -CGFloat(joke.latOffset * 8000), y: -CGFloat(joke.lonOffset * 8000))
                                withAnimation(.spring()) {
                                    selectedJoke = joke
                                    showJokePopup = true
                                }
                            }) {
                                ZStack {
                                    Capsule()
                                        .fill(themeManager.currentTheme.cardBackground)
                                        .overlay(Capsule().stroke(themeManager.currentTheme.secondaryAccent.opacity(0.4), lineWidth: 1))
                                        .frame(width: 80, height: 32)
                                        .shadow(color: themeManager.currentTheme.secondaryAccent.opacity(0.3), radius: 6)
                                    
                                    HStack(spacing: 4) {
                                        Text("💬")
                                            .font(.system(size: 11))
                                        Text("Joke")
                                            .font(.system(size: 10, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .position(x: jx, y: jy)
                        }
                    }
                    
                    // Emit Floating Emojis Signals particles
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
                            withAnimation(.spring(response: 0.52, dampingFraction: 0.78)) {
                                cameraTargetOffset.width += mapDraggedOffset.width
                                cameraTargetOffset.height += mapDraggedOffset.height
                                mapDraggedOffset = .zero
                            }
                        }
                )
            }
            .ignoresSafeArea()
            
            // ==========================================
            // HUD HEADS-UP COCKPIT OVERLAYS
            // ==========================================
            VStack {
                // Centered Dynamic Island overlay mockup
                DynamicIslandMockup()
                    .padding(.top, 10)
                
                // Top layer info title bar
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(getLayerSubheading())
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            Text(getLayerHeading())
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.3), radius: 6)
                        }
                        Spacer()
                        
                        // Add Button trigger context actions per layers
                        if appViewModel.activeTab == .memories {
                            Button(action: {
                                SoundManager.shared.playClick()
                                withAnimation(.spring()) {
                                    if memoryTabSegment == .moments {
                                        showBroadcastDrawer = true
                                    } else {
                                        showExpenseDrawer = true
                                    }
                                }
                            }) {
                                HUDCircleButton(icon: "plus.circle.fill")
                            }
                        } else if appViewModel.activeTab == .profile {
                            Button(action: {
                                SoundManager.shared.playClick()
                                withAnimation(.spring()) {
                                    showThemeDrawer = true
                                }
                            }) {
                                HUDCircleButton(icon: "paintpalette.fill")
                            }
                        }
                    }
                    
                    if appViewModel.activeTab == .memories {
                        // Glassmorphic Custom Segment Control
                        HStack(spacing: 0) {
                            ForEach(MemoryTabSegment.allCases) { segment in
                                Button(action: {
                                    SoundManager.shared.playClick()
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        memoryTabSegment = segment
                                    }
                                }) {
                                    Text(segment.rawValue)
                                        .font(.system(size: 11, weight: .bold, design: .rounded))
                                        .foregroundColor(memoryTabSegment == segment ? .white : .white.opacity(0.5))
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(memoryTabSegment == segment ? .white.opacity(0.08) : .clear)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .frame(width: 200)
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                Spacer()
                
                // ==========================================
                // BOTTOM FLOATING CARD SLIDER FOR OVERVIEW LAYER
                // ==========================================
                if appViewModel.activeTab == .home {
                    VStack(spacing: 8) {
                        Capsule()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 36, height: 5)
                            .padding(.top, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ACTIVE TRIP PLANET")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                Text(appViewModel.activeTrip.title)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("Pot: $\(Int(appViewModel.activeTrip.cost))")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeManager.currentTheme.primaryAccent.opacity(0.15))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        
                        if isDetailDrawerExpanded {
                            VStack(alignment: .leading, spacing: 14) {
                                Divider().background(Color.white.opacity(0.1))
                                
                                Text("NEXT TIMELINE AGENDA")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                
                                ForEach(appViewModel.activeTrip.upcomingEvents.prefix(2)) { event in
                                    TimelineItemRow(event: event)
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Text("LIVE LOCK SCREEN ACTIVITY")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                
                                LiveActivityWidget()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 24).fill(themeManager.currentTheme.cardBackground).background(.ultraThinMaterial))
                    .cornerRadius(24)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 110)
                    .onTapGesture {
                        SoundManager.shared.playClick()
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                            isDetailDrawerExpanded.toggle()
                        }
                    }
                }
            }
            
            // Bottom Tab Bar layer filter deck
            VStack {
                Spacer()
                FloatingTabBar(activeTab: $appViewModel.activeTab)
                    .padding(.bottom, 24)
                    .onChange(of: appViewModel.activeTab) { tab in
                        cameraTargetOffset = .zero // reset panning targets
                    }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            // ==========================================
            // LAYER POPOVERS & DRAWERS SHEETS
            // ==========================================
            
            // 1. Friends Details Bubble
            if showFriendPopup, let friend = selectedFriend {
                PopBackdropDimmer {
                    showFriendPopup = false
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
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Text("STATUS:")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                Text(friend.status)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            // Map quick emoji signals reactions deck!
                            HStack {
                                Text("Signal reaction:")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                Spacer()
                                HStack(spacing: 10) {
                                    ForEach(["🔥", "⚡️", "🍜", "🍻", "🚗"], id: \.self) { emoji in
                                        Button(action: {
                                            emitMapReaction(emoji)
                                        }) {
                                            Text(emoji).font(.title3).padding(6).background(.white.opacity(0.08)).clipShape(Circle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 2. Parallel Memories timeline drawer
            if showMemoryDrawer, let memory = selectedMemory {
                PopBackdropDimmer {
                    showMemoryDrawer = false
                }
                
                VStack {
                    Spacer()
                    MemoryCard(memory: memory)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 3. Spontaneous Chaos Roulette spinner drawer in-place!
            if showChaosSpinner, let adventure = selectedAdventure {
                PopBackdropDimmer {
                    showChaosSpinner = false
                }
                
                VStack {
                    Spacer()
                    
                    GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.secondaryAccent) {
                        VStack(alignment: .center, spacing: 20) {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showChaosSpinner = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            // Spontaneous roulette wheel
                            ZStack {
                                Circle()
                                    .strokeBorder(themeManager.currentTheme.primaryAccent, lineWidth: 2)
                                    .background(Circle().fill(.white.opacity(0.04)))
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(orbitAngle * 5))
                                
                                ForEach(0..<4) { i in
                                    Text(["🕹️", "🎤", "🧗‍♂️", "🍢"][i])
                                        .font(.system(size: 20))
                                        .offset(y: -60)
                                        .rotationEffect(.degrees(Double(i) * 90.0 + orbitAngle * 5))
                                }
                                
                                Button(action: {
                                    triggerInPlaceRoulette()
                                }) {
                                    Circle()
                                        .fill(themeManager.currentTheme.accentGradient)
                                        .frame(width: 50, height: 50)
                                        .shadow(color: themeManager.currentTheme.primaryAccent, radius: 10)
                                        .overlay(Image(systemName: "sparkles").foregroundColor(.white))
                                }
                            }
                            
                            VStack(spacing: 4) {
                                Text(adventure.title)
                                    .font(.system(.headline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(adventure.subtitle)
                                    .font(.system(size: 11))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                
                                Text(adventure.recommendationDescription)
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 4. Inside Joke dialog bubble popup
            if showJokePopup, let joke = selectedJoke {
                PopBackdropDimmer {
                    showJokePopup = false
                }
                
                VStack {
                    Spacer()
                    
                    GlassCard(cornerRadius: 24, fillOpacity: 0.16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("📢 GROUP INSIDE JOKE")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(themeManager.currentTheme.secondaryAccent)
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showJokePopup = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            Text("\"" + joke.quote + "\"")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineSpacing(4)
                            
                            Text("Anchored by " + joke.author)
                                .font(.system(size: 10))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 5. Visual settings theme changer drawer
            if showThemeDrawer {
                PopBackdropDimmer {
                    showThemeDrawer = false
                }
                
                VStack {
                    Spacer()
                    GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("App Visual Themes")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showThemeDrawer = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(OrbitTheme.allCases) { theme in
                                        Button(action: {
                                            themeManager.setTheme(theme)
                                            SoundManager.shared.playClick()
                                        }) {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .fill(theme.primaryAccent)
                                                    .frame(width: 32, height: 32)
                                                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                                
                                                Text(theme.rawValue.split(separator: " ").first!)
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 10)
                                            .background(themeManager.currentTheme == theme ? .white.opacity(0.08) : .white.opacity(0.02))
                                            .cornerRadius(12)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            Divider().background(Color.white.opacity(0.12))
                            
                            // Log out portal options
                            Button(action: {
                                showThemeDrawer = false
                                appViewModel.logOut()
                            }) {
                                HStack {
                                    Image(systemName: "power").font(.subheadline)
                                    Text("Logout Matrix OS").font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(Color(hex: "ff006e"))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "ff006e").opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 6. Memories Broadcast moments drawer
            if showBroadcastDrawer {
                PopBackdropDimmer {
                    showBroadcastDrawer = false
                }
                
                VStack {
                    Spacer()
                    GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.secondaryAccent) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack {
                                Text("Broadcast Moment Here")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showBroadcastDrawer = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            GlassTextField(placeholder: "Moment Name", icon: "pencil", text: $broadcastTitle)
                            GlassTextField(placeholder: "Local details...", icon: "doc.text.fill", text: $broadcastCaption)
                            
                            BreathingButton(title: "Commit Anchor Pin", icon: "sparkles", isGlowing: true) {
                                if !broadcastTitle.isEmpty && !broadcastCaption.isEmpty {
                                    appViewModel.postNewMemory(
                                        title: broadcastTitle,
                                        caption: broadcastCaption,
                                        accentColors: [[Color(hex: "ff007f"), Color(hex: "7000ff")].randomElement()!, [Color(hex: "00f5d4"), Color(hex: "3a86ff")].randomElement()!]
                                    )
                                    
                                    broadcastTitle = ""
                                    broadcastCaption = ""
                                    withAnimation(.spring()) {
                                        showBroadcastDrawer = false
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 7. Expense details popup drawer
            if showExpensePopup, let expense = selectedExpense {
                PopBackdropDimmer {
                    showExpensePopup = false
                }
                
                VStack {
                    Spacer()
                    GlassCard(cornerRadius: 24, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(themeManager.currentTheme.primaryAccent.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: getCategoryIcon(expense.category))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(expense.title)
                                        .font(.system(.headline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Category: \(expense.category)")
                                        .font(.system(size: 11))
                                        .foregroundColor(themeManager.currentTheme.secondaryText)
                                }
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showExpensePopup = false
                                        selectedExpense = nil
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            HStack {
                                Text("Total Spent:")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                Spacer()
                                Text("$\(String(format: "%.2f", expense.amount))")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Text("Paid by \(expense.payer.name)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            Text("SPLIT DETAILS")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(expense.splits) { split in
                                        VStack(spacing: 6) {
                                            Text(split.user.avatar)
                                                .font(.title3)
                                            Text(split.user.name.split(separator: " ").first ?? "")
                                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                            Text("$\(String(format: "%.2f", split.amount))")
                                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                .foregroundColor(themeManager.currentTheme.secondaryAccent)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white.opacity(0.04))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 8. Log New Expense popover drawer
            if showExpenseDrawer {
                PopBackdropDimmer {
                    showExpenseDrawer = false
                }
                
                VStack {
                    Spacer()
                    GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack {
                                Text("Log New Expense")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showExpenseDrawer = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.white.opacity(0.4))
                                }
                            }
                            
                            GlassTextField(placeholder: "Expense Title (e.g. Ramen)", icon: "cart.fill", text: $expenseTitle)
                            GlassTextField(placeholder: "Amount ($0.00)", icon: "dollarsign.circle.fill", text: $expenseAmount)
                                .keyboardType(.decimalPad)
                            
                            // Category Selector
                            Text("Select Category:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                            
                            HStack(spacing: 8) {
                                ForEach(["General", "Nightlife", "Memories", "Entertainment"], id: \.self) { cat in
                                    Button(action: {
                                        expenseCategory = cat
                                        SoundManager.shared.playClick()
                                    }) {
                                        Text(cat)
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(expenseCategory == cat ? .white : themeManager.currentTheme.secondaryText)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(expenseCategory == cat ? themeManager.currentTheme.primaryAccent : .white.opacity(0.06))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            
                            BreathingButton(title: "Commit Split Bill", icon: "creditcard.fill", isGlowing: true) {
                                if let amt = Double(expenseAmount), !expenseTitle.isEmpty {
                                    let splitFriends = [appViewModel.currentUser, appViewModel.friends[0], appViewModel.friends[1]]
                                    let randLat = Double.random(in: -0.02...0.02)
                                    let randLon = Double.random(in: -0.02...0.02)
                                    
                                    appViewModel.addExpense(
                                        title: expenseTitle,
                                        amount: amt,
                                        payer: appViewModel.currentUser,
                                        splitUsers: splitFriends,
                                        category: expenseCategory,
                                        latOffset: randLat,
                                        lonOffset: randLon
                                    )
                                    
                                    expenseTitle = ""
                                    expenseAmount = ""
                                    withAnimation(.spring()) {
                                        showExpenseDrawer = false
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onReceive(orbitTimer) { _ in
            orbitAngle += 0.35
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: false)) {
                radarPulse = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                activePulseGlow = true
            }
        }
    }
    
    // Core helper text
    private func getLayerHeading() -> String {
        switch appViewModel.activeTab {
        case .home: return "Overview Deck"
        case .map: return "Friends Signal"
        case .memories: return "Memory Anchors"
        case .chaos: return "Chaos Anomaly"
        case .profile: return "Friendship OS"
        }
    }
    
    private func getLayerSubheading() -> String {
        switch appViewModel.activeTab {
        case .home: return "COSMIC TRIP PLOT"
        case .map: return "COORDINATE RADAR ACTIVE"
        case .memories: return "GEOGRAPHIC snaps"
        case .chaos: return "SPONTANEOUS VECTOR"
        case .profile: return "GROUP CORE SHIELD"
        }
    }
    
    private func panCameraTo(x: CGFloat, y: CGFloat) {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
            cameraTargetOffset = CGSize(width: x, height: y)
        }
    }
    
    // Localized roulette spin
    private func triggerInPlaceRoulette() {
        SoundManager.shared.playTransition()
        let ticks: [Double] = [0.05, 0.1, 0.15, 0.2, 0.26, 0.32, 0.38, 0.45, 0.52, 0.6, 0.7, 0.8, 0.95, 1.1, 1.3, 1.5, 1.75, 2.05, 2.4, 2.8]
        for delay in ticks {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                SoundManager.shared.playTick()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            SoundManager.shared.playSuccess()
            withAnimation(.spring()) {
                showChaosSpinner = false
            }
        }
    }
    
    // reaction emitter ticks
    private func emitMapReaction(_ char: String) {
        SoundManager.shared.playTick()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<5 {
            let p = FloatingEmojiParticle(
                char: char,
                position: CGPoint(x: screenWidth / 2, y: screenHeight * 0.78),
                scale: 0.1,
                opacity: 1.0,
                size: CGFloat.random(in: 20...32)
            )
            emittedEmojis.append(p)
            let particleId = p.id
            
            withAnimation(.spring(response: 0.58, dampingFraction: 0.72)) {
                if let i = emittedEmojis.firstIndex(where: { $0.id == particleId }) {
                    emittedEmojis[i].position = CGPoint(
                        x: screenWidth / 2 + CGFloat.random(in: -80...80),
                        y: screenHeight * 0.45 + CGFloat.random(in: -100...100)
                    )
                    emittedEmojis[i].scale = 1.3
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 0.8)) {
                    if let i = emittedEmojis.firstIndex(where: { $0.id == particleId }) {
                        emittedEmojis[i].opacity = 0.0
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    emittedEmojis.removeAll(where: { $0.id == particleId })
                }
            }
        }
    }
}

// Subordinate helpers
struct HUDCircleButton: View {
    var icon: String
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
        }
    }
}

struct PopBackdropDimmer: View {
    var tapAction: () -> Void
    var body: some View {
        Color.black.opacity(0.45)
            .ignoresSafeArea()
            .transition(.opacity)
            .onTapGesture(perform: tapAction)
    }
}
