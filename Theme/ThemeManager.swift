import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: OrbitTheme = .midnightOrbit
    
    func setTheme(_ theme: OrbitTheme) {
        withAnimation(.easeInOut(duration: 0.8)) {
            self.currentTheme = theme
        }
        
        // Sync theme selection to Supabase profiles database when configured
        guard SupabaseService.shared.isConfigured,
              let activeToken = AuthManager.shared.activeToken else { return }
        
        // Parse user identity locally or execute PATCH
        guard let url = URL(string: "\(SupabaseService.shared.supabaseURL)/rest/v1/profiles") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(SupabaseService.shared.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(activeToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let patchBody: [String: String] = ["active_emoji": theme.rawValue]
        request.httpBody = try? JSONEncoder().encode(patchBody)
        
        URLSession.shared.dataTask(with: request).resume()
    }
}
