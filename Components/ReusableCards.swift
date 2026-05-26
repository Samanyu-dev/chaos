import SwiftUI

// MARK: - TRIP CARD
struct TripCard: View {
    var trip: Trip
    var isExpanded: Bool = false
    var action: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            GlassCard(cornerRadius: 24, fillOpacity: 0.1, hasGlow: isExpanded, glowColor: themeManager.currentTheme.primaryAccent) {
                VStack(alignment: .leading, spacing: 14) {
                    // Header Area
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.title)
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.currentTheme.primaryText)
                            
                            Text(trip.subtitle)
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        
                        Spacer()
                        
                        // Active Countdown badge
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(trip.daysLeft)")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            Text("DAYS LEFT")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    
                    // Route visual / Progress slider
                    HStack(spacing: 8) {
                        Circle()
                            .fill(themeManager.currentTheme.primaryAccent)
                            .frame(width: 8, height: 8)
                            .shadow(color: themeManager.currentTheme.primaryAccent, radius: 4)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.currentTheme.primaryAccent, themeManager.currentTheme.secondaryAccent],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .frame(height: 3)
                        
                        Image(systemName: "airplane")
                            .foregroundColor(themeManager.currentTheme.secondaryAccent)
                            .font(.system(size: 14, weight: .bold))
                    }
                    
                    // Footer details: Dates, Friend group avatars, Budget summary
                    HStack {
                        Label(trip.startDate + " - " + trip.endDate, systemImage: "calendar")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(themeManager.currentTheme.secondaryText)
                        
                        Spacer()
                        
                        // Overlapping friends
                        AnimatedAvatarCluster(friends: trip.friends, size: 28, overlap: 10)
                    }
                    
                    if isExpanded {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Up Next in Timeline:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            ForEach(trip.upcomingEvents.prefix(2)) { event in
                                TimelineItemRow(event: event)
                            }
                        }
                        .transition(.opacity.combined(with: .slide))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - TIMELINE ITEM ROW
struct TimelineItemRow: View {
    var event: ItineraryItem
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Text(event.time)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.white.opacity(0.06))
                .cornerRadius(6)
            
            Text(event.emoji)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(themeManager.currentTheme.primaryText)
                Text(event.details)
                    .font(.system(size: 10))
                    .foregroundColor(themeManager.currentTheme.secondaryText)
            }
        }
    }
}

// MARK: - MEMORY CARD
struct MemoryCard: View {
    var memory: Memory
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isLiked = false
    @State private var likeCount: Int
    
    init(memory: Memory) {
        self.memory = memory
        self._likeCount = State(initialValue: memory.likes)
    }
    
    var body: some View {
        GlassCard(cornerRadius: 26, fillOpacity: 0.12) {
            VStack(alignment: .leading, spacing: 12) {
                // Header: Author & Perspective
                HStack(spacing: 10) {
                    Text(memory.senderAvatar)
                        .font(.system(size: 26))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(memory.senderName)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.currentTheme.primaryText)
                        
                        Text(memory.perspectiveName)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                    }
                    
                    Spacer()
                    
                    Text(memory.relativeTime)
                        .font(.system(size: 11))
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                
                // Memory Visual Backdrop (procedural stunning glow cards)
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: memory.gradientColors,
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay(
                        ZStack {
                            // Artistic spatial visual outlines
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            
                            // Visual overlay showing details
                            VStack {
                                Spacer()
                                HStack {
                                    Text(memory.title)
                                        .font(.system(.headline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.6), radius: 4)
                                    Spacer()
                                }
                                .padding(16)
                            }
                        }
                    )
                    .shadow(color: memory.gradientColors[0].opacity(0.3), radius: 10, y: 5)
                
                // Caption
                Text(memory.caption)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(themeManager.currentTheme.primaryText.opacity(0.85))
                    .lineLimit(3)
                
                // Footer interactions
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                            isLiked.toggle()
                            likeCount += isLiked ? 1 : -1
                        }
                        
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? Color.red : themeManager.currentTheme.secondaryText)
                                .scaleEffect(isLiked ? 1.25 : 1.0)
                            
                            Text("\(likeCount)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    // Map coordinate link indicator
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 11))
                        Text("Shibuya Alley Map Link")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                }
            }
        }
    }
}

// MARK: - EXPENSE CARD
struct ExpenseCard: View {
    var expense: Expense
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GlassCard(cornerRadius: 20, fillOpacity: 0.1) {
            HStack(spacing: 14) {
                // Category icon with neon circular backdrop
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.primaryAccent.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: getCategoryIcon(expense.category))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(expense.title)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryText)
                        .lineLimit(1)
                    
                    Text("Paid by \(expense.payer.name) • \(formatExpenseDate(expense.timestamp))")
                        .font(.system(size: 10))
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("$\(String(format: "%.2f", expense.amount))")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryText)
                    
                    // Share breakdown text
                    let mySplit = expense.splits.first(where: { $0.user.isMe })?.amount ?? 0
                    Text(mySplit > 0 ? "Your share: $\(String(format: "%.2f", mySplit))" : "Not involved")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(themeManager.currentTheme.secondaryAccent)
                }
            }
        }
    }
    
    private func getCategoryIcon(_ cat: String) -> String {
        switch cat {
        case "Nightlife": return "wineglass.fill"
        case "Memories":  return "photo.fill"
        case "Entertainment": return "guitars.fill"
        default: return "creditcard.fill"
        }
    }
    
    private func formatExpenseDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - SOCIAL STATS CARD
struct SocialStatsCard: View {
    var title: String
    var val: String
    var icon: String
    var subtitle: String
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GlassCard(cornerRadius: 18, fillOpacity: 0.08) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                    Spacer()
                }
                
                Text(val)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(themeManager.currentTheme.primaryText)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryText)
                    Text(subtitle)
                        .font(.system(size: 9))
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
            }
        }
    }
}
