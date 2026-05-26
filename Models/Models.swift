import Foundation
import SwiftUI

struct User: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var username: String
    var avatar: String // Emoji or SF Symbol
    var status: String
    var activeEmoji: String
    var latOffset: Double // Offset for mapping simulation
    var lonOffset: Double // Offset for mapping simulation
    var isMe: Bool = false
}

struct Trip: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var startDate: String
    var endDate: String
    var bannerColors: [Color]
    var cost: Double
    var upcomingEvents: [ItineraryItem]
    var friends: [User]
    var daysLeft: Int
}

struct ItineraryItem: Identifiable, Hashable {
    var id = UUID()
    var time: String
    var title: String
    var details: String
    var emoji: String
}

struct Memory: Identifiable, Hashable {
    var id = UUID()
    var tripId: UUID
    var title: String
    var senderName: String
    var senderAvatar: String
    var caption: String
    var relativeTime: String
    var likes: Int
    var perspectiveName: String
    var gradientColors: [Color]
    var imageURL: String? = nil
    var latOffset: Double
    var lonOffset: Double
}

struct ExpenseSplit: Identifiable, Hashable {
    var id = UUID()
    var user: User
    var amount: Double
    var isSettled: Bool = false
}

struct Expense: Identifiable, Hashable {
    var id = UUID()
    var tripId: UUID
    var title: String
    var amount: Double
    var payer: User
    var splits: [ExpenseSplit]
    var category: String
    var timestamp: Date
}

struct ChaosAdventure: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var mood: String
    var locationEmoji: String
    var icon: String
    var rating: Double
    var recommendationDescription: String
}
