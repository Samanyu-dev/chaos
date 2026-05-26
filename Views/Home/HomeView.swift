import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isTripExpanded = false
    @State private var animateEntrance = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Centered Dynamic Island Mockup (tap to expand)
                HStack {
                    Spacer()
                    DynamicIslandMockup()
                    Spacer()
                }
                .padding(.top, 10)
                
                // Header Profile bar
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Active Orbit")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                        
                        Text("Hey, Alex!")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(themeManager.currentTheme.primaryText)
                    }
                    
                    Spacer()
                    
                    // Companion guide micro orb
                    FloatingOrbGuide(text: "Co-traveling levels are stable.", showSpeechBubble: false)
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                // Weather & Countdown widget row
                HStack(spacing: 12) {
                    // Weather Glass module
                    GlassCard(cornerRadius: 18, fillOpacity: 0.1) {
                        HStack(spacing: 12) {
                            Text("☀️")
                                .font(.title)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Tokyo Hot")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("28°C • Clear Skies")
                                    .font(.system(size: 10))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                            }
                        }
                    }
                    
                    // Group Budget summary module
                    GlassCard(cornerRadius: 18, fillOpacity: 0.1) {
                        HStack(spacing: 12) {
                            Text("💸")
                                .font(.title)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Shared Pot")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("$\(String(format: "%.2f", appViewModel.activeTrip.cost)) spent")
                                    .font(.system(size: 10))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // MAIN TRIP HUB HEADER
                Text("Current Active Trip")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                    .padding(.horizontal, 20)
                
                // Primary Trip Card View
                TripCard(trip: appViewModel.activeTrip, isExpanded: isTripExpanded) {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) {
                        isTripExpanded.toggle()
                    }
                }
                .padding(.horizontal, 20)
                
                // Live Activity Lock Screen widget mockup
                Text("Live Activity Lock Screen Widget")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                    .padding(.horizontal, 20)
                
                LiveActivityWidget()
                    .padding(.horizontal, 20)

                
                // Spontaneous quick actions panel
                Text("Spontaneous Quick Actions")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 12) {
                    QuickActionNode(emoji: "☄️", title: "Chaos Mode", desc: "Launch roulette") {
                        withAnimation {
                            appViewModel.activeTab = .chaos
                        }
                    }
                    
                    QuickActionNode(emoji: "📍", title: "Live Mapping", desc: "Locate crew") {
                        withAnimation {
                            appViewModel.activeTab = .map
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Itinerary timeline preview details
                if !isTripExpanded {
                    Text("Today's Itinerary")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(appViewModel.activeTrip.upcomingEvents) { event in
                            GlassCard(cornerRadius: 16, fillOpacity: 0.08) {
                                TimelineItemRow(event: event)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                    .frame(height: 120) // Bottom spacing spacer to support floating tab bar scrolling
            }
            .opacity(animateEntrance ? 1.0 : 0.0)
            .offset(y: animateEntrance ? 0 : 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                animateEntrance = true
            }
        }
    }
}

// Quick action widget representation
struct QuickActionNode: View {
    var emoji: String
    var title: String
    var desc: String
    var action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            GlassCard(cornerRadius: 18, fillOpacity: 0.1) {
                HStack(spacing: 12) {
                    Text(emoji)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(desc)
                            .font(.system(size: 9))
                            .foregroundColor(themeManager.currentTheme.secondaryText)
                    }
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
