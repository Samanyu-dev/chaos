import SwiftUI

enum OrbitTheme: String, CaseIterable, Identifiable {
    case midnightOrbit = "Midnight Orbit"
    case neonNightlife = "Neon Nightlife"
    case sunsetDrive = "Sunset Drive"
    case arcticMinimal = "Arctic Minimal"
    case cyberGlow = "Cyber Glow"
    case tokyoNights = "Tokyo Nights"
    
    var id: String { self.rawValue }
    
    // Core Background Color
    var backgroundColor: Color {
        switch self {
        case .midnightOrbit: return Color(hex: "080810")
        case .neonNightlife: return Color(hex: "05020c")
        case .sunsetDrive:   return Color(hex: "120b08")
        case .arcticMinimal: return Color(hex: "0f1215")
        case .cyberGlow:     return Color(hex: "000508")
        case .tokyoNights:   return Color(hex: "0b0816")
        }
    }
    
    // Glowing Accent Colors
    var primaryAccent: Color {
        switch self {
        case .midnightOrbit: return Color(hex: "3a86ff") // Electric Blue
        case .neonNightlife: return Color(hex: "d90429") // Hot Neon Pinkish-Red
        case .sunsetDrive:   return Color(hex: "ffb703") // Radiant Gold
        case .arcticMinimal: return Color(hex: "e0fbfc") // Frost Silver-Blue
        case .cyberGlow:     return Color(hex: "00f5d4") // Cyber Teal
        case .tokyoNights:   return Color(hex: "ff007f") // Shibuya Hot Magenta
        }
    }
    
    var secondaryAccent: Color {
        switch self {
        case .midnightOrbit: return Color(hex: "8338ec") // Intense Purple
        case .neonNightlife: return Color(hex: "ff006e") // Vivid Pink
        case .sunsetDrive:   return Color(hex: "fb8500") // Sunset Orange
        case .arcticMinimal: return Color(hex: "98c1d9") // Calm Blue
        case .cyberGlow:     return Color(hex: "7b2cbf") // Electric Violet
        case .tokyoNights:   return Color(hex: "7000ff") // Cyber purple
        }
    }
    
    var ambientGlow: Color {
        switch self {
        case .midnightOrbit: return Color(hex: "3a86ff").opacity(0.15)
        case .neonNightlife: return Color(hex: "ff006e").opacity(0.18)
        case .sunsetDrive:   return Color(hex: "fb8500").opacity(0.15)
        case .arcticMinimal: return Color(hex: "e0fbfc").opacity(0.08)
        case .cyberGlow:     return Color(hex: "00f5d4").opacity(0.20)
        case .tokyoNights:   return Color(hex: "ff007f").opacity(0.22)
        }
    }
    
    // Card Background Color
    var cardBackground: Color {
        switch self {
        case .arcticMinimal:
            return Color.white.opacity(0.05)
        default:
            return Color(hex: "1c1c2e").opacity(0.35)
        }
    }
    
    // Card Border Color
    var cardBorder: Color {
        switch self {
        case .arcticMinimal:
            return Color.white.opacity(0.15)
        default:
            return Color.white.opacity(0.08)
        }
    }
    
    // Text Color
    var primaryText: Color {
        switch self {
        case .arcticMinimal: return Color(hex: "f8f9fa")
        default: return .white
        }
    }
    
    var secondaryText: Color {
        switch self {
        case .arcticMinimal: return Color(hex: "adb5bd")
        default: return Color.white.opacity(0.6)
        }
    }
    
    // Ambient Gradients for screens & cards
    var backgroundGradient: LinearGradient {
        switch self {
        case .midnightOrbit:
            return LinearGradient(
                colors: [Color(hex: "0c0c1e"), Color(hex: "05050c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .neonNightlife:
            return LinearGradient(
                colors: [Color(hex: "180325"), Color(hex: "05010a")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .sunsetDrive:
            return LinearGradient(
                colors: [Color(hex: "24120a"), Color(hex: "080302")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .arcticMinimal:
            return LinearGradient(
                colors: [Color(hex: "171d22"), Color(hex: "0a0d0f")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .cyberGlow:
            return LinearGradient(
                colors: [Color(hex: "02131e"), Color(hex: "000205")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .tokyoNights:
            return LinearGradient(
                colors: [Color(hex: "1d0828"), Color(hex: "07020d")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
    
    var accentGradient: LinearGradient {
        LinearGradient(
            colors: [primaryAccent, secondaryAccent],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    // Particle Speed and Density config for custom backgrounds
    var animationSpeedMultiplier: Double {
        switch self {
        case .midnightOrbit: return 1.0
        case .neonNightlife: return 1.4
        case .sunsetDrive:   return 0.8
        case .arcticMinimal: return 0.4
        case .cyberGlow:     return 1.8
        case .tokyoNights:   return 1.5
        }
    }
}

// Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
