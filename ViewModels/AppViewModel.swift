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
    
    @Published var memories: [Memory] = []
    @Published var expenses: [Expense] = []
    @Published var chaosOptions: [ChaosAdventure] = MockData.chaosOptions
    
    @Published var isChaosSpinning: Bool = false
    @Published var selectedChaosAdventure: ChaosAdventure? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var activeTrip: Trip {
        guard activeTripIndex < trips.count else { return trips[0] }
        return trips[activeTripIndex]
    }
    
    init() {
        // Automatically sync with Apple Sign-in state
        AuthManager.shared.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authenticated in
                guard let self = self else { return }
                if authenticated {
                    self.appState = .mainTab
                    self.fetchBackendData()
                } else {
                    if self.appState == .mainTab {
                        self.appState = .auth
                    }
                }
            }
            .store(in: &cancellables)
            
        // Initial data loading fallbacks
        self.memories = MockData.memories
        self.expenses = MockData.expenses
    }
    
    // Sync active data from Supabase Service
    func fetchBackendData() {
        let token = AuthManager.shared.activeToken
        
        MemoryService.shared.fetchMemories(jwtToken: token) { [weak self] loadedMemories in
            self?.memories = loadedMemories
        }
        
        ExpenseService.shared.fetchExpenses(jwtToken: token) { [weak self] loadedExpenses in
            self?.expenses = loadedExpenses
        }
    }
    
    // Actions & Methods
    func completeSplash() {
        SoundManager.shared.playTransition()
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .onboarding
        }
    }
    
    func completeOnboarding() {
        SoundManager.shared.playTransition()
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .auth
        }
    }
    
    func completeAuth() {
        SoundManager.shared.playTransition()
        // Fallback for manual bypass passcode (e.g. Apple Review credentials '1997')
        AuthManager.shared.isAuthenticated = true
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .mainTab
        }
    }
    
    func logOut() {
        SoundManager.shared.logout()
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
            self.appState = .auth
            self.activeTab = .home
        }
    }
    
    func addExpense(title: String, amount: Double, payer: User, splitUsers: [User], category: String, latOffset: Double, lonOffset: Double) {
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
            category: category,
            timestamp: Date(),
            latOffset: latOffset,
            lonOffset: lonOffset
        )
        
        // Optimistic UI updates
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            self.expenses.insert(newExpense, at: 0)
        }
        
        // Dispatch insert payload to Supabase
        ExpenseService.shared.uploadExpense(expense: newExpense, jwtToken: AuthManager.shared.activeToken) { _ in
            // DB completes upload sync in background
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
        
        // Optimistic UI updates
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            self.memories.insert(newMemory, at: 0)
        }
        
        // Dispatch insert payload to Supabase
        MemoryService.shared.uploadMemory(memory: newMemory, jwtToken: AuthManager.shared.activeToken) { _ in
            // DB completes upload sync in background
        }
    }
}
