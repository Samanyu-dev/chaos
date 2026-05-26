import Foundation
import SwiftUI

struct MockData {
    
    // Core Friends
    static let me = User(
        name: "Alex Carter",
        username: "@alex",
        avatar: "⚡️",
        status: "Navigating local chaos",
        activeEmoji: "🧭",
        latOffset: 0.0,
        lonOffset: 0.0,
        isMe: true
    )
    
    static let friends: [User] = [
        User(name: "Kai Vance", username: "@kai", avatar: "👾", status: "Finding hidden ramen spots", activeEmoji: "🍜", latOffset: 0.015, lonOffset: -0.008),
        User(name: "Lila Chen", username: "@lila", avatar: "🌸", status: "Taking analog photos", activeEmoji: "📸", latOffset: -0.012, lonOffset: 0.018),
        User(name: "Aris Miller", username: "@aris", avatar: "🌌", status: "DJing in a Tokyo basement", activeEmoji: "🎧", latOffset: 0.008, lonOffset: -0.014),
        User(name: "Talon Reed", username: "@talon", avatar: "🦅", status: "Climbing rooftops", activeEmoji: "🧗‍♂️", latOffset: -0.005, lonOffset: -0.021),
        User(name: "Sora Takahashi", username: "@sora", avatar: "🪁", status: "Chasing retro neon arcade high scores", activeEmoji: "🕹️", latOffset: 0.022, lonOffset: 0.012)
    ]
    
    // Custom Trips
    static let sampleTripId1 = UUID()
    static let sampleTripId2 = UUID()
    
    static let trips: [Trip] = [
        Trip(
            id: sampleTripId1,
            title: "Tokyo Neon Nights",
            subtitle: "Summer Spontaneous Odyssey",
            startDate: "Jul 12",
            endDate: "Jul 22",
            bannerColors: [Color(hex: "ff007f"), Color(hex: "7000ff")],
            cost: 2450.0,
            upcomingEvents: [
                ItineraryItem(time: "20:00", title: "Robot Restaurant Revived", details: "Shinjuku electric showdown", emoji: "🤖"),
                ItineraryItem(time: "23:30", title: "Midnight Golden Gai Crawl", details: "Spontaneous bar routing with local crew", emoji: "🍻"),
                ItineraryItem(time: "05:00", title: "Tsukiji Sunrise Auction", details: "Catching freshest fatty tuna before sleep", emoji: "🍣")
            ],
            friends: [friends[0], friends[1], friends[2]],
            daysLeft: 4
        ),
        Trip(
            id: sampleTripId2,
            title: "Reykjavik Volcanic Road",
            subtitle: "Arctic Glaciers & Aurora",
            startDate: "Sep 04",
            endDate: "Sep 12",
            bannerColors: [Color(hex: "00f5d4"), Color(hex: "3a86ff")],
            cost: 3800.0,
            upcomingEvents: [
                ItineraryItem(time: "10:00", title: "Black Sand Quad Biking", details: "Vik Coast extreme drift routing", emoji: "🏍️"),
                ItineraryItem(time: "19:00", title: "Thermal Lagoon Gathering", details: "Soaking inside lava canyons with hot tea", emoji: "♨️"),
                ItineraryItem(time: "22:00", title: "Aurora Borealis Hunt", details: "Spontaneous north wind chase", emoji: "🌌")
            ],
            friends: [friends[1], friends[3], friends[4]],
            daysLeft: 45
        )
    ]
    
    // Shared Parallel Memories
    static let memories: [Memory] = [
        Memory(
            tripId: sampleTripId1,
            title: "Lost in Shibuya Alley",
            senderName: "Kai Vance",
            senderAvatar: "👾",
            caption: "Found this 6-seat bar hidden under a metal ladder. Aris bargained with the bartender using visual notes. Best highball of the journey.",
            relativeTime: "2 hours ago",
            likes: 42,
            perspectiveName: "Kai's Perspective",
            gradientColors: [Color(hex: "7000ff"), Color(hex: "3a86ff")],
            latOffset: 0.015,
            lonOffset: -0.008
        ),
        Memory(
            tripId: sampleTripId1,
            title: "Shibuya Crossing Cyber Blur",
            senderName: "Lila Chen",
            senderAvatar: "🌸",
            caption: "Told Kai to stand perfectly static in the middle of the crowd. Exposed for 2.5s on retro film while everything else melted around him.",
            relativeTime: "1 hour ago",
            likes: 56,
            perspectiveName: "Lila's Perspective",
            gradientColors: [Color(hex: "ff007f"), Color(hex: "7000ff")],
            latOffset: -0.012,
            lonOffset: 0.018
        ),
        Memory(
            tripId: sampleTripId1,
            title: "Sub-Basement Synthesizers",
            senderName: "Aris Miller",
            senderAvatar: "🌌",
            caption: "Synthesizer feedback looping off concrete blocks. They let us control the modulation filter with our hands. Live sensory mapping.",
            relativeTime: "10 mins ago",
            likes: 18,
            perspectiveName: "Aris's Perspective",
            gradientColors: [Color(hex: "00f5d4"), Color(hex: "ffb703")],
            latOffset: 0.008,
            lonOffset: -0.014
        )
    ]
    
    // Live Split Expenses
    static let expenses: [Expense] = [
        Expense(
            tripId: sampleTripId1,
            title: "Golden Gai Bar Crawl Entry & Sake",
            amount: 180.00,
            payer: friends[0], // Kai paid
            splits: [
                ExpenseSplit(user: me, amount: 60.00),
                ExpenseSplit(user: friends[0], amount: 60.00),
                ExpenseSplit(user: friends[1], amount: 60.00)
            ],
            category: "Nightlife",
            timestamp: Date().addingTimeInterval(-3600 * 4)
        ),
        Expense(
            tripId: sampleTripId1,
            title: "Vintage Film Roll Pack (5 Pack)",
            amount: 85.00,
            payer: friends[1], // Lila paid
            splits: [
                ExpenseSplit(user: me, amount: 28.33),
                ExpenseSplit(user: friends[0], amount: 28.33),
                ExpenseSplit(user: friends[1], amount: 28.34)
            ],
            category: "Memories",
            timestamp: Date().addingTimeInterval(-3600 * 24)
        ),
        Expense(
            tripId: sampleTripId1,
            title: "Roppongi Basement Club VIP DJ Pass",
            amount: 320.00,
            payer: me, // Alex paid
            splits: [
                ExpenseSplit(user: me, amount: 80.00),
                ExpenseSplit(user: friends[0], amount: 80.00),
                ExpenseSplit(user: friends[1], amount: 80.00),
                ExpenseSplit(user: friends[2], amount: 80.00)
            ],
            category: "Entertainment",
            timestamp: Date().addingTimeInterval(-3600 * 2)
        )
    ]
    
    // Chaos Mode Spontaneous Generator options
    static let chaosOptions: [ChaosAdventure] = [
        ChaosAdventure(
            title: "Midnight Arcade High-Score Duel",
            subtitle: "Akihabara retro zone",
            mood: "Chaotic",
            locationEmoji: "🕹️",
            icon: "gamecontroller.fill",
            rating: 4.9,
            recommendationDescription: "Sensory overload guaranteed. The loser buys fresh matcha crêpes at 3 AM. Retro rhythms & extreme buttons."
        ),
        ChaosAdventure(
            title: "Lost Tunnel Echo Karaoke",
            subtitle: "Abandoned Shinjuku pipeline",
            mood: "Eerie & Cinematic",
            locationEmoji: "🎤",
            icon: "waveform.circle.fill",
            rating: 4.7,
            recommendationDescription: "A mini sound system hidden inside an architectural drainage cavity. Perfect reverb for off-beat synth covers."
        ),
        ChaosAdventure(
            title: "Roof Climbing Aurora Watch",
            subtitle: "Uncharted high vistas",
            mood: "Exhilarating",
            locationEmoji: "🧗‍♂️",
            icon: "wind",
            rating: 4.8,
            recommendationDescription: "Climb past standard fire escapes to view Shibuya's neon grid meeting the upper high-altitude wind currents."
        ),
        ChaosAdventure(
            title: "Spontaneous Street Food Wheel Spin",
            subtitle: "Unmapped back alleys",
            mood: "Adventurous",
            locationEmoji: "🍢",
            icon: "sparkles",
            rating: 4.6,
            recommendationDescription: "Close your eyes and walk exactly 150 paces down a tiny street. Order item #4 at whatever stall you hit."
        )
    ]
}
