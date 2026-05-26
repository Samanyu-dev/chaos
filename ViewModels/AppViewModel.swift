import Foundation
import SwiftUI
import Combine

enum AppState {
    case splash
    case onboarding
    case auth
    case mainTab
}

enum ActiveTab: Int {
    case home = 0
    case map = 1
    case memories = 2
    case chaos = 3
    case profile = 4
}

class AppViewModel: ObservableObject {
    // Navigation / Flow States
    @Published var appState: AppState = .splash
    @Published var activeTab: ActiveTab = .home
    
    // Core Application Data Bindings
    @Published var currentUser: User = MockData.me
    @Published var friends: [User] = MockData.friends
    @Published var trips: [Trip] = MockData.trips
    @Published var activeTripIndex: Int = 0
    
    @Published var memories: [Memory] = MockData.memories
    @Published var expenses: [Expense] = MockData.expenses
    @Published var chaosOptions: [ChaosAdventure] = MockData.chaosOptions
    
    @Published var isChaosSpinning: Bool = false
    @Published var selectedChaosAdventure: ChaosAdventure? = nil
    
    var activeTrip: Trip {
        guard activeTripIndex < trips.count else { return trips[0] }
        return trips[activeTripIndex]
    }
    
    // Actions & Methods
    func completeSplash() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .onboarding
        }
    }
    
    func completeOnboarding() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .auth
        }
    }
    
    func completeAuth() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .mainTab
        }
    }
    
    func logOut() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .auth
            self.activeTab = .home
        }
    }
    
    func addExpense(title: String, amount: Double, payer: User, splitUsers: [User]) {
        let splitAmount = amount / Double(splitUsers.count)
        let splitEntries = splitUsers.map { user in
            ExpenseSplit(user: user, amount: splitAmount)
        }
        
        let newExpense = Expense(
            tripId: activeTrip.id,
            title: title,
            amount: amount,
            payer: payer,
            splits: splitEntries,
            category: "General",
            timestamp: Date()
        )
        
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            self.expenses.insert(newExpense, at: 0)
        }
    }
    
    func spinChaosWheel() {
        guard !isChaosSpinning else { return }
        isChaosSpinning = true
        selectedChaosAdventure = nil
        
        // Simulate roulette speed deceleration
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                self.selectedChaosAdventure = self.chaosOptions.randomElement()
                self.isChaosSpinning = false
            }
        }
    }
    
    func updateMyStatus(status: String, emoji: String) {
        self.currentUser.status = status
        self.currentUser.activeEmoji = emoji
    }
    
    func postNewMemory(title: String, caption: String, accentColors: [Color]) {
        let newMemory = Memory(
            tripId: activeTrip.id,
            title: title,
            senderName: currentUser.name,
            senderAvatar: currentUser.avatar,
            caption: caption,
            relativeTime: "Just now",
            likes: 0,
            perspectiveName: "My Perspective",
            gradientColors: accentColors,
            latOffset: Double.random(in: -0.02...0.02),
            lonOffset: Double.random(in: -0.02...0.02)
        )
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            self.memories.insert(newMemory, at: 0)
        }
    }
}
