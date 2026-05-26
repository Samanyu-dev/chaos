import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    
    let totalPages = 5
    
    var body: some View {
        ZStack {
            // Immersive background layer
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // 3D-like Parallax Visual Scene Layer
            GeometryReader { geo in
                ZStack {
                    // Page 1 Visual: Floating globe & orbiting rings
                    OnboardingScene1(dragOffset: dragOffset, page: currentPage, size: geo.size)
                    
                    // Page 2 Visual: Route vectors & flight indicators
                    OnboardingScene2(dragOffset: dragOffset, page: currentPage, size: geo.size)
                    
                    // Page 3 Visual: Floating photo slots & parallel timelines
                    OnboardingScene3(dragOffset: dragOffset, page: currentPage, size: geo.size)
                    
                    // Page 4 Visual: Spontaneous roulette elements & particles
                    OnboardingScene4(dragOffset: dragOffset, page: currentPage, size: geo.size)
                    
                    // Page 5 Visual: Social Streaks & coordination charts
                    OnboardingScene5(dragOffset: dragOffset, page: currentPage, size: geo.size)
                }
            }
            .ignoresSafeArea()
            
            // Content Overlays & Text Panels
            VStack {
                Spacer()
                
                // Narrative Onboarding details
                ZStack {
                    ForEach(0..<totalPages, id: \.self) { index in
                        if index == currentPage {
                            VStack(spacing: 8) {
                                Text(getOnboardingTitle(index))
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(themeManager.currentTheme.primaryText)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.3), radius: 8)
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                                
                                Text(getOnboardingSubtitle(index))
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
                .frame(height: 120)
                
                // Companion Guide speech overlays
                FloatingOrbGuide(text: getOrbGuideText(currentPage), showSpeechBubble: true)
                    .padding(.bottom, 30)
                
                // Indicators & Action buttons
                HStack {
                    // Page progress indicators
                    HStack(spacing: 6) {
                        ForEach(0..<totalPages, id: \.self) { idx in
                            Capsule()
                                .fill(idx == currentPage ? themeManager.currentTheme.primaryAccent : Color.white.opacity(0.15))
                                .frame(width: idx == currentPage ? 24 : 6, height: 6)
                        }
                    }
                    
                    Spacer()
                    
                    if currentPage < totalPages - 1 {
                        // Forward Navigation button
                        Button(action: {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                                currentPage += 1
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(themeManager.currentTheme.accentGradient)
                                    .frame(width: 54, height: 54)
                                    .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 10)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        // Onboarding complete -> Auth
                        BreathingButton(title: "Start Your Orbit", icon: "sparkles", isGlowing: true) {
                            appViewModel.completeOnboarding()
                        }
                        .frame(width: 220)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let threshold: CGFloat = 50
                    if gesture.translation.width < -threshold {
                        if currentPage < totalPages - 1 {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                                currentPage += 1
                            }
                        }
                    } else if gesture.translation.width > threshold {
                        if currentPage > 0 {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                                currentPage -= 1
                            }
                        }
                    }
                }
        )
    }
    
    // Core details
    private func getOnboardingTitle(_ index: Int) -> String {
        switch index {
        case 0: return "Welcome to Orbit"
        case 1: return "Trips Together"
        case 2: return "Parallel Memories"
        case 3: return "Chaos Mode"
        default: return "Friendship OS"
        }
    }
    
    private func getOnboardingSubtitle(_ index: Int) -> String {
        switch index {
        case 0: return "Your social life deserves its own operating system. Live maps, active memories, and split billing."
        case 1: return "Collaborative travel mapping and itineraries. Plan, schedule, and sync routes beautifully."
        case 2: return "Parallel timelines show you everyone's snapshots at the exact same hour. Deeply emotional recaps."
        case 3: return "Feeling spontaneous? Spin the adventure generator to unlock chaotic nearby cafe hunts and mystery tours."
        default: return "Group playlists, activity streaks, inside joke records, and detailed yearly group rewind stories."
        }
    }
    
    private func getOrbGuideText(_ index: Int) -> String {
        switch index {
        case 0: return "Greetings! I am Orbit Guide. I will be your companion in this friendship matrix!"
        case 1: return "We synchronize active map positions so nobody gets lost in back alley Shibuya."
        case 2: return "I automatically stitch multi-user photo angles into a cinematic visual recap."
        case 3: return "Ready to take a random drive? Spin the roulette for pure unmapped fun!"
        default: return "Awesome! Let's initialize your profile coordinates. Click start!"
        }
    }
}

// MARK: - SCENE 1 VISUAL (Welcome Orbit)
struct OnboardingScene1: View {
    var dragOffset: CGFloat
    var page: Int
    var size: CGSize
    @State private var isSpinning = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if page == 0 {
                ZStack {
                    // Floating central planet
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [themeManager.currentTheme.primaryAccent, themeManager.currentTheme.secondaryAccent],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 20)
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))
                    
                    // Ring layer
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 220, height: 220)
                    
                    // Orbiting friend indicators
                    ForEach(0..<3) { idx in
                        ZStack {
                            Circle()
                                .fill(themeManager.currentTheme.cardBackground)
                                .frame(width: 42, height: 42)
                                .overlay(Circle().stroke(themeManager.currentTheme.primaryAccent, lineWidth: 1.5))
                            
                            Text(["👾", "🌸", "🌌"][idx])
                                .font(.system(size: 20))
                        }
                        .offset(x: 110)
                        .rotationEffect(.degrees(Double(idx) * 120.0 + (isSpinning ? 360 : 0)))
                    }
                }
                .position(x: size.width / 2, y: size.height * 0.4)
                .transition(.scale.combined(with: .opacity))
                .onAppear {
                    withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                        isSpinning = true
                    }
                }
            }
        }
    }
}

// MARK: - SCENE 2 VISUAL (Trips Route vectors)
struct OnboardingScene2: View {
    var dragOffset: CGFloat
    var page: Int
    var size: CGSize
    @State private var animatePlane = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if page == 1 {
                ZStack {
                    // Curved neon path representer
                    Path { path in
                        path.move(to: CGPoint(x: 50, y: 350))
                        path.addQuadCurve(to: CGPoint(x: size.width - 50, y: 220), control: CGPoint(x: size.width / 2, y: 120))
                    }
                    .trim(from: 0, to: animatePlane ? 1.0 : 0.0)
                    .stroke(
                        LinearGradient(
                            colors: [themeManager.currentTheme.primaryAccent, themeManager.currentTheme.secondaryAccent],
                            startPoint: .leading, endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 6])
                    )
                    
                    // Glowing Destination nodes
                    DestinationPinNode(emoji: "🗼", name: "Tokyo", pos: CGPoint(x: 50, y: 350))
                    DestinationPinNode(emoji: "🌋", name: "Reykjavik", pos: CGPoint(x: size.width - 60, y: 220))
                    
                    // Plane traversing
                    if animatePlane {
                        Image(systemName: "airplane")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                            .shadow(color: themeManager.currentTheme.primaryAccent, radius: 5)
                            .offset(x: -12, y: -12)
                            .modifier(PathFollower(pct: animatePlane ? 1.0 : 0.0, path: Path { path in
                                path.move(to: CGPoint(x: 50, y: 350))
                                path.addQuadCurve(to: CGPoint(x: size.width - 50, y: 220), control: CGPoint(x: size.width / 2, y: 120))
                            }))
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .onAppear {
                    withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: false)) {
                        animatePlane = true
                    }
                }
            }
        }
    }
}

struct DestinationPinNode: View {
    var emoji: String
    var name: String
    var pos: CGPoint
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                
                Text(emoji)
                    .font(.system(size: 24))
            }
            Text(name)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .position(pos)
    }
}

// Geometry path follower helper
struct PathFollower: GeometryEffect {
    var pct: CGFloat
    var path: Path
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let point = path.element(at: pct)
        return ProjectionTransform(CGAffineTransform(translationX: point.x, y: point.y))
    }
}

extension Path {
    func element(at percentage: CGFloat) -> CGPoint {
        let clamped = max(0.0, min(1.0, percentage))
        guard clamped > 0.0 else { return cgPath.currentPoint }
        
        let totalLength = cgPath.length()
        let targetLength = totalLength * clamped
        
        var currentLength: CGFloat = 0
        var lastPoint = CGPoint.zero
        var targetPoint = CGPoint.zero
        
        cgPath.applyWithBlock { elementPtr in
            let element = elementPtr.pointee
            switch element.type {
            case .moveToPoint:
                lastPoint = element.points[0]
            case .addLineToPoint:
                let nextPoint = element.points[0]
                let segmentLength = lastPoint.distance(to: nextPoint)
                if currentLength + segmentLength >= targetLength {
                    let remaining = targetLength - currentLength
                    let factor = remaining / segmentLength
                    targetPoint = CGPoint(
                        x: lastPoint.x + (nextPoint.x - lastPoint.x) * factor,
                        y: lastPoint.y + (nextPoint.y - lastPoint.y) * factor
                    )
                    currentLength = targetLength
                } else {
                    currentLength += segmentLength
                }
                lastPoint = nextPoint
            case .addQuadCurveToPoint:
                let control = element.points[0]
                let end = element.points[1]
                // simplified linear approximation for quad curves
                let steps = 15
                var tempLast = lastPoint
                for i in 1...steps {
                    let t = CGFloat(i) / CGFloat(steps)
                    let x = (1 - t) * (1 - t) * lastPoint.x + 2 * (1 - t) * t * control.x + t * t * end.x
                    let y = (1 - t) * (1 - t) * lastPoint.y + 2 * (1 - t) * t * control.y + t * t * end.y
                    let stepPoint = CGPoint(x: x, y: y)
                    let stepLen = tempLast.distance(to: stepPoint)
                    if currentLength + stepLen >= targetLength {
                        let remaining = targetLength - currentLength
                        let factor = remaining / stepLen
                        targetPoint = CGPoint(
                            x: tempLast.x + (stepPoint.x - tempLast.x) * factor,
                            y: tempLast.y + (stepPoint.y - tempLast.y) * factor
                        )
                        currentLength = targetLength
                        break
                    } else {
                        currentLength += stepLen
                    }
                    tempLast = stepPoint
                }
                lastPoint = end
            default:
                break
            }
        }
        return targetPoint
    }
}

extension CGPath {
    func length() -> CGFloat {
        var totalLength: CGFloat = 0
        var lastPoint = CGPoint.zero
        applyWithBlock { elementPtr in
            let element = elementPtr.pointee
            switch element.type {
            case .moveToPoint:
                lastPoint = element.points[0]
            case .addLineToPoint:
                let nextPoint = element.points[0]
                totalLength += lastPoint.distance(to: nextPoint)
                lastPoint = nextPoint
            case .addQuadCurveToPoint:
                let control = element.points[0]
                let end = element.points[1]
                let steps = 10
                var tempLast = lastPoint
                for i in 1...steps {
                    let t = CGFloat(i) / CGFloat(steps)
                    let x = (1 - t) * (1 - t) * lastPoint.x + 2 * (1 - t) * t * control.x + t * t * end.x
                    let y = (1 - t) * (1 - t) * lastPoint.y + 2 * (1 - t) * t * control.y + t * t * end.y
                    let stepPoint = CGPoint(x: x, y: y)
                    totalLength += tempLast.distance(to: stepPoint)
                    tempLast = stepPoint
                }
                lastPoint = end
            default: break
            }
        }
        return totalLength
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

// MARK: - SCENE 3 VISUAL (Parallel Memories)
struct OnboardingScene3: View {
    var dragOffset: CGFloat
    var page: Int
    var size: CGSize
    @State private var hoverShift = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if page == 2 {
                ZStack {
                    // Floating memory card left
                    GlassCard(cornerRadius: 16, fillOpacity: 0.15) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(colors: [themeManager.currentTheme.primaryAccent, themeManager.currentTheme.secondaryAccent], startPoint: .top, endPoint: .bottom))
                                .frame(width: 90, height: 95)
                            Text("🌸 Lila's View")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 110)
                    .offset(x: -80, y: hoverShift ? -15 : 15)
                    
                    // Floating memory card right
                    GlassCard(cornerRadius: 16, fillOpacity: 0.15) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(colors: [Color(hex: "00f5d4"), Color(hex: "3a86ff")], startPoint: .top, endPoint: .bottom))
                                .frame(width: 90, height: 95)
                            Text("👾 Kai's View")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 110)
                    .offset(x: 80, y: hoverShift ? 15 : -15)
                }
                .position(x: size.width / 2, y: size.height * 0.4)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                        hoverShift.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - SCENE 4 VISUAL (Chaos Roulette)
struct OnboardingScene4: View {
    var dragOffset: CGFloat
    var page: Int
    var size: CGSize
    @State private var spinWheel = 0.0
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if page == 3 {
                ZStack {
                    // Roulette wheel graphics
                    Circle()
                        .strokeBorder(themeManager.currentTheme.primaryAccent, lineWidth: 2)
                        .background(Circle().fill(.white.opacity(0.04)))
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(spinWheel))
                    
                    // Grid spokes inside the wheel
                    ForEach(0..<8) { i in
                        Rectangle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 1, height: 180)
                            .rotationEffect(.degrees(Double(i) * 45.0 + spinWheel))
                    }
                    
                    // Dynamic adventure tags orbiting
                    ForEach(0..<4) { i in
                        Text(["☕️", "🎢", "🗼", "🍜"][i])
                            .font(.system(size: 26))
                            .offset(y: -75)
                            .rotationEffect(.degrees(Double(i) * 90.0 + spinWheel))
                    }
                    
                    // Center indicator core
                    Circle()
                        .fill(themeManager.currentTheme.accentGradient)
                        .frame(width: 44, height: 44)
                        .shadow(color: themeManager.currentTheme.primaryAccent, radius: 10)
                        .overlay(Image(systemName: "sparkles").foregroundColor(.white))
                }
                .position(x: size.width / 2, y: size.height * 0.4)
                .transition(.scale)
                .onAppear {
                    withAnimation(.spring(response: 2.5, dampingFraction: 0.6).repeatForever(autoreverses: false)) {
                        spinWheel = 720.0
                    }
                }
            }
        }
    }
}

// MARK: - SCENE 5 VISUAL (Friendship OS streaking)
struct OnboardingScene5: View {
    var dragOffset: CGFloat
    var page: Int
    var size: CGSize
    @State private var scaleCharts = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            if page == 4 {
                VStack(spacing: 12) {
                    // Interactive dynamic streak bubble
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(themeManager.currentTheme.primaryAccent.opacity(0.15))
                                .frame(width: 50, height: 50)
                            Text("🔥")
                                .font(.system(size: 26))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Group Streak")
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("182 days active together")
                                .font(.system(size: 11))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    .frame(width: 280)
                    .scaleEffect(scaleCharts ? 1.0 : 0.8)
                    
                    // Simulated visual playlist node
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(themeManager.currentTheme.secondaryAccent.opacity(0.2))
                                .frame(width: 50, height: 50)
                            Image(systemName: "music.note.list")
                                .foregroundColor(themeManager.currentTheme.secondaryAccent)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Shibuya Alley Vibe")
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Collaborative Spotify Playlist")
                                .font(.system(size: 11))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    .frame(width: 280)
                    .scaleEffect(scaleCharts ? 1.0 : 0.8)
                }
                .position(x: size.width / 2, y: size.height * 0.4)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .scale))
                .onAppear {
                    withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
                        scaleCharts = true
                    }
                }
            }
        }
    }
}
