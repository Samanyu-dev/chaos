import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Animating background overlay across tabs
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // Core Tab Routing
            ZStack {
                switch appViewModel.activeTab {
                case .home:
                    HomeView()
                case .map:
                    LiveMapView()
                case .memories:
                    MemoriesView()
                case .chaos:
                    ChaosView()
                case .profile:
                    ProfileView()
                }
            }
            .transition(.opacity)
            
            // Bottom Floating Glass Tab Bar
            VStack {
                Spacer()
                
                FloatingTabBar(activeTab: $appViewModel.activeTab)
                    .padding(.bottom, 24)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
