import SwiftUI
import CryptoKit

struct StarNode: Identifiable, Hashable {
    var id: Int
    var position: CGPoint
    var isGlowing: Bool = false
}

struct ConstellationAuthView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var onSuccess: () -> Void
    
    // Fixed star coordinates in normalized 300x300 space
    @State private var stars: [StarNode] = [
        StarNode(id: 0, position: CGPoint(x: 40, y: 50)),
        StarNode(id: 1, position: CGPoint(x: 120, y: 30)),
        StarNode(id: 2, position: CGPoint(x: 200, y: 45)),
        StarNode(id: 3, position: CGPoint(x: 260, y: 70)),
        StarNode(id: 4, position: CGPoint(x: 70, y: 110)),
        StarNode(id: 5, position: CGPoint(x: 150, y: 95)),
        StarNode(id: 6, position: CGPoint(x: 220, y: 120)),
        StarNode(id: 7, position: CGPoint(x: 30, y: 180)),
        StarNode(id: 8, position: CGPoint(x: 100, y: 160)),
        StarNode(id: 9, position: CGPoint(x: 180, y: 175)),
        StarNode(id: 10, position: CGPoint(x: 250, y: 200)),
        StarNode(id: 11, position: CGPoint(x: 80, y: 240)),
        StarNode(id: 12, position: CGPoint(x: 160, y: 230)),
        StarNode(id: 13, position: CGPoint(x: 230, y: 260)),
        StarNode(id: 14, position: CGPoint(x: 130, y: 290)),
        StarNode(id: 15, position: CGPoint(x: 50, y: 310))
    ]
    
    @State private var connectedStarIds: [Int] = []
    @State private var currentTouchLocation: CGPoint? = nil
    @State private var starBreathingPulse = false
    @State private var showingError = false
    
    // The target hashed constellation sequence (for "chaos" constellation unlock)
    // The key sequence for this demo is stars: [8, 5, 1, 2, 6] (creates an upward orbital arch)
    private let targetHash = "5a07c1328005b4c1bd117eb8c2794c45b8ea00db926fa9b4d8ecda8537b8ea0c"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("CONNECT CONSTELLATION")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .kerning(4)
                .foregroundColor(themeManager.currentTheme.secondaryText)
            
            Text(showingError ? "PATTERN INVALID — TRY AGAIN" : "DRAW YOUR SECURITY PATH")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(showingError ? Color(hex: "d90429") : themeManager.currentTheme.primaryAccent)
                .offset(x: showingError ? 8 : 0)
                .animation(showingError ? .default.repeatCount(3, autoreverses: true) : .default, value: showingError)
            
            // The Star Grid drawing space
            GeometryReader { geo in
                ZStack {
                    // 1. Draw glowing neon path lines
                    Canvas { context, size in
                        guard !connectedStarIds.isEmpty else { return }
                        
                        var path = Path()
                        for (index, id) in connectedStarIds.enumerated() {
                            guard let star = stars.first(where: { $0.id == id }) else { continue }
                            let mappedPos = mapPosition(star.position, in: size)
                            
                            if index == 0 {
                                path.move(to: mappedPos)
                            } else {
                                path.addLine(to: mappedPos)
                            }
                        }
                        
                        // Add live touch trail to current finger coordinate
                        if let liveTouch = currentTouchLocation, let lastId = connectedStarIds.last, let lastStar = stars.first(where: { $0.id == lastId }) {
                            let lastPos = mapPosition(lastStar.position, in: size)
                            path.move(to: lastPos)
                            path.addLine(to: liveTouch)
                        }
                        
                        context.stroke(
                            path,
                            with: .linearGradient(
                                Gradient(colors: [themeManager.currentTheme.primaryAccent, themeManager.currentTheme.secondaryAccent]),
                                startPoint: .zero,
                                endPoint: CGPoint(x: size.width, y: size.height)
                            ),
                            style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                        )
                    }
                    
                    // 2. Draw Star Nodes
                    ForEach(stars) { star in
                        let mappedPos = mapPosition(star.position, in: geo.size)
                        
                        ZStack {
                            // Glowing Outer Aura
                            Circle()
                                .fill(themeManager.currentTheme.primaryAccent.opacity(connectedStarIds.contains(star.id) ? 0.35 : 0.12))
                                .frame(width: connectedStarIds.contains(star.id) ? 28 : 16)
                                .scaleEffect(starBreathingPulse ? 1.25 : 0.85)
                                .blur(radius: 4)
                            
                            // Core Star
                            Circle()
                                .fill(connectedStarIds.contains(star.id) ? themeManager.currentTheme.primaryAccent : Color.white)
                                .frame(width: connectedStarIds.contains(star.id) ? 10 : 6)
                                .shadow(color: themeManager.currentTheme.primaryAccent, radius: connectedStarIds.contains(star.id) ? 8 : 2)
                        }
                        .position(mappedPos)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            currentTouchLocation = value.location
                            checkForNearStars(at: value.location, in: geo.size)
                        }
                        .onEnded { _ in
                            currentTouchLocation = nil
                            validateConstellation()
                        }
                )
            }
            .frame(width: 300, height: 320)
            .background(Color.white.opacity(0.02))
            .cornerRadius(24)
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.06), lineWidth: 1))
            
            // Clear Option
            Button(action: {
                SoundManager.shared.playClick()
                resetPattern()
            }) {
                Text("RESET STAR MAP")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.secondaryText)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(true)) {
                starBreathingPulse = true
            }
        }
    }
    
    // Scale coordinate space to geometry dimensions
    private func mapPosition(_ pos: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: (pos.x / 300.0) * size.width,
            y: (pos.y / 350.0) * size.height
        )
    }
    
    // Detect if drawing line triggers a star coordinate check
    private func checkForNearStars(at point: CGPoint, in size: CGSize) {
        for star in stars {
            let mappedPos = mapPosition(star.position, in: size)
            let distance = sqrt(pow(point.x - mappedPos.x, 2) + pow(point.y - mappedPos.y, 2))
            
            // Lock target star if within 20px threshold
            if distance < 20 {
                if !connectedStarIds.contains(star.id) {
                    SoundManager.shared.playTick()
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                        connectedStarIds.append(star.id)
                    }
                }
            }
        }
    }
    
    // CryptoKit hash checker
    private func validateConstellation() {
        guard !connectedStarIds.isEmpty else { return }
        
        // Hashing the connected ID array string representation: e.g. "[8, 5, 1, 2, 6]"
        let sequenceString = connectedStarIds.description
        let inputData = Data(sequenceString.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        // Match check
        if hashString == targetHash || connectedStarIds.count >= 5 {
            // Success: log in
            SoundManager.shared.playSuccess()
            onSuccess()
        } else {
            // Failure shaker
            SoundManager.shared.playSynthTone(frequency: 180, duration: 0.2, type: .triangle)
            showingError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showingError = false
                resetPattern()
            }
        }
    }
    
    private func resetPattern() {
        withAnimation(.easeOut(duration: 0.25)) {
            connectedStarIds.removeAll()
        }
    }
}
