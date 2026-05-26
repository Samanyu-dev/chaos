import SwiftUI

@main
struct OrbitApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Top-Level Application State Switcher
                switch appViewModel.appState {
                case .splash:
                    SplashScreenView()
                        .transition(.opacity)
                case .onboarding:
                    OnboardingView()
                        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                case .auth:
                    AuthView()
                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
                case .mainTab:
                    MainTabView()
                        .transition(.opacity)
                }
            }
            .environmentObject(appViewModel)
            .environmentObject(themeManager)
            .preferredColorScheme(.dark) // Deep cinematic ambient defaults
        }
    }
}
