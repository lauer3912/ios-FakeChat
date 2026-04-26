import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
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

struct Theme {
    static let darkBackground = Color(hex: "0D0D0F")
    static let darkSurface = Color(hex: "1A1A1F")
    static let darkCard = Color(hex: "232328")
    static let accentCyan = Color(hex: "00D4FF")
    static let accentPink = Color(hex: "FF2D7A")
    static let accentPurple = Color(hex: "A855F7")
    static let accentYellow = Color(hex: "FFFC00")
    static let success = Color(hex: "30D158")
    static let warning = Color(hex: "FF9F0A")
    static let textSecondary = Color(hex: "8E8E93")

    static let lightBackground = Color(hex: "F2F2F7")
    static let lightSurface = Color(hex: "FFFFFF")
    static let lightText = Color(hex: "000000")
    static let lightTextSecondary = Color(hex: "3C3C43")
}

struct AppTheme {
    @AppStorage("isDarkMode") static var isDarkMode: Bool = true
    @AppStorage("hapticEnabled") static var hapticEnabled: Bool = true
    @AppStorage("defaultApp") static var defaultApp: String = ChatApp.iMessage.rawValue
    @AppStorage("defaultWallpaper") static var defaultWallpaper: String = "default"

    static var background: Color { isDarkMode ? Theme.darkBackground : Theme.lightBackground }
    static var surface: Color { isDarkMode ? Theme.darkSurface : Theme.lightSurface }
    static var card: Color { isDarkMode ? Theme.darkCard : Theme.lightSurface }
    static var textPrimary: Color { isDarkMode ? .white : Theme.lightText }
    static var textSecondary: Color { isDarkMode ? Theme.textSecondary : Theme.lightTextSecondary }
    static var accent: Color { accentCyan }
}