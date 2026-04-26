import UIKit

extension UIColor {
    convenience init(hex: String) {
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
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

struct Theme {
    static let darkBackground = UIColor(hex: "0D0D0F")
    static let darkSurface = UIColor(hex: "1A1A1F")
    static let darkCard = UIColor(hex: "232328")
    static let accentCyan = UIColor(hex: "00D4FF")
    static let accentPink = UIColor(hex: "FF2D7A")
    static let accentPurple = UIColor(hex: "A855F7")
    static let accentYellow = UIColor(hex: "FFFC00")
    static let success = UIColor(hex: "30D158")
    static let warning = UIColor(hex: "FF9F0A")
    static let textSecondary = UIColor(hex: "8E8E93")

    static let lightBackground = UIColor(hex: "F2F2F7")
    static let lightSurface = UIColor(hex: "FFFFFF")
    static let lightText = UIColor(hex: "000000")
    static let lightTextSecondary = UIColor(hex: "3C3C43")
}

struct AppTheme {
    @AppStorage("isDarkMode") static var isDarkMode: Bool = true
    @AppStorage("hapticEnabled") static var hapticEnabled: Bool = true
    @AppStorage("defaultApp") static var defaultApp: String = ChatApp.iMessage.rawValue
    @AppStorage("defaultWallpaper") static var defaultWallpaper: String = "default"

    static var background: UIColor { isDarkMode ? Theme.darkBackground : Theme.lightBackground }
    static var surface: UIColor { isDarkMode ? Theme.darkSurface : Theme.lightSurface }
    static var card: UIColor { isDarkMode ? Theme.darkCard : Theme.lightSurface }
    static var textPrimary: UIColor { isDarkMode ? .white : Theme.lightText }
    static var textSecondary: UIColor { isDarkMode ? Theme.textSecondary : Theme.lightTextSecondary }
    static var accent: UIColor { Theme.accentCyan }
}

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