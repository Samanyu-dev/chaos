import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: OrbitTheme = .midnightOrbit
    
    func setTheme(_ theme: OrbitTheme) {
        withAnimation(.easeInOut(duration: 0.8)) {
            self.currentTheme = theme
        }
    }
}
