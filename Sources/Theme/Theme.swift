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
    
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: -abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(
            red: min(red + percentage, 1.0),
            green: min(green + percentage, 1.0),
            blue: min(blue + percentage, 1.0),
            alpha: alpha
        )
    }
}

// MARK: - Design System Colors
struct Design {
    // MARK: - Backgrounds
    static let bgPrimary = UIColor(hex: "0A0A0F")
    static let bgSecondary = UIColor(hex: "12121A")
    static let bgTertiary = UIColor(hex: "1C1C26")
    static let bgElevated = UIColor(hex: "242430")
    
    // MARK: - Accent Colors (Neon Vibes)
    static let cyan = UIColor(hex: "00D4FF")
    static let pink = UIColor(hex: "FF2D7A")
    static let purple = UIColor(hex: "A855F7")
    static let yellow = UIColor(hex: "FFFC00")
    static let green = UIColor(hex: "30D158")
    static let orange = UIColor(hex: "FF9F0A")
    
    // MARK: - Glass Effect
    static let glassBg = UIColor.white.withAlphaComponent(0.08)
    static let glassBorder = UIColor.white.withAlphaComponent(0.15)
    
    // MARK: - Gradients
    struct Gradients {
        static let cyanPink = [UIColor(hex: "00D4FF"), UIColor(hex: "FF2D7A")]
        static let purpleCyan = [UIColor(hex: "A855F7"), UIColor(hex: "00D4FF")]
        static let pinkOrange = [UIColor(hex: "FF2D7A"), UIColor(hex: "FF9F0A")]
        static let dark = [UIColor(hex: "0A0A0F"), UIColor(hex: "1C1C26")]
        
        static func forApp(_ app: ChatApp) -> [CGColor] {
            switch app {
            case .iMessage: return [UIColor(hex: "007AFF").cgColor, UIColor(hex: "5856D6").cgColor]
            case .telegram: return [UIColor(hex: "0088CC").cgColor, UIColor(hex: "00D4FF").cgColor]
            case .snapchat: return [UIColor(hex: "FFFC00").cgColor, UIColor(hex: "FF2D7A").cgColor]
            case .whatsapp: return [UIColor(hex: "25D366").cgColor, UIColor(hex: "128C7E").cgColor]
            case .instagramDM: return [UIColor(hex: "E1306C").cgColor, UIColor(hex: "F77737").cgColor]
            case .twitterX: return [UIColor(hex: "FFFFFF").cgColor, UIColor(hex: "8E8E93").cgColor]
            case .discord: return [UIColor(hex: "5865F2").cgColor, UIColor(hex: "7289DA").cgColor]
            }
        }
    }
    
    // MARK: - Shadows
    struct Shadows {
        static func apply(to layer: CALayer, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 20, offset: CGSize = CGSize(width: 0, height: 10)) {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowRadius = radius
            layer.shadowOffset = offset
            layer.masksToBounds = false
        }
        
        static func glow(to layer: CALayer, color: UIColor, radius: CGFloat = 30) {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = 0.8
            layer.shadowRadius = radius
            layer.shadowOffset = .zero
        }
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subhead = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
        static let full: CGFloat = 9999
    }
}

// MARK: - AppTheme with Dark/Light
class AppTheme {
    static let defaults = UserDefaults.standard
    
    static var isDarkMode: Bool {
        get { defaults.bool(forKey: "isDarkMode") }
        set { defaults.set(newValue, forKey: "isDarkMode") }
    }
    
    static var hapticEnabled: Bool {
        get { defaults.object(forKey: "hapticEnabled") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "hapticEnabled") }
    }
    
    static var defaultApp: String {
        get { defaults.string(forKey: "defaultApp") ?? ChatApp.iMessage.rawValue }
        set { defaults.set(newValue, forKey: "defaultApp") }
    }
    
    static var defaultWallpaper: String {
        get { defaults.string(forKey: "defaultWallpaper") ?? "default" }
        set { defaults.set(newValue, forKey: "defaultWallpaper") }
    }
    
    static var background: UIColor { isDarkMode ? Design.bgPrimary : UIColor(hex: "F2F2F7") }
    static var surface: UIColor { isDarkMode ? Design.bgSecondary : UIColor.white }
    static var elevated: UIColor { isDarkMode ? Design.bgTertiary : UIColor.white }
    static var card: UIColor { isDarkMode ? Design.bgElevated : UIColor.white }
    static var textPrimary: UIColor { isDarkMode ? .white : UIColor(hex: "000000") }
    static var textSecondary: UIColor { isDarkMode ? UIColor(hex: "8E8E93") : UIColor(hex: "3C3C43") }
    static var accent: UIColor { Design.cyan }
}