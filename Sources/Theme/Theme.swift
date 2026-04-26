import UIKit

// MARK: - Design System (2026 Award-winning style)
struct Design {
    // MARK: - Colors
    struct Colors {
        // Primary Backgrounds
        static let backgroundPrimary = UIColor(hex: "0D0D0F")
        static let backgroundSecondary = UIColor(hex: "1A1A1F")
        static let backgroundCard = UIColor(hex: "1C1C1E")
        
        // Accent Colors (Neon)
        static let accentCyan = UIColor(hex: "00D4FF")
        static let accentPink = UIColor(hex: "FF2D7A")
        static let accentPurple = UIColor(hex: "A855F7")
        static let accentYellow = UIColor(hex: "FCD34D")
        static let accentGreen = UIColor(hex: "30D158")
        static let accentOrange = UIColor(hex: "FF9F0A")
        
        // Text
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor(hex: "8E8E93")
        static let textTertiary = UIColor(hex: "636366")
        
        // Semantic
        static let success = accentGreen
        static let warning = accentOrange
        static let error = UIColor(hex: "EF4444")
        
        // Light theme
        static let lightBackground = UIColor(hex: "F2F2F7")
        static let lightCard = UIColor.white
        static let lightText = UIColor.black
    }
    
    // MARK: - Gradients
    struct Gradients {
        static func forApp(_ app: ChatApp) -> [CGColor] {
            return [app.primaryColor.cgColor, app.secondaryColor.cgColor]
        }
        
        static let accent: [CGColor] = [
            Colors.accentCyan.cgColor,
            Colors.accentPurple.cgColor
        ]
        
        static let sunset: [CGColor] = [
            UIColor(hex: "FF2D7A").cgColor,
            UIColor(hex: "FCD34D").cgColor
        ]
        
        static let ocean: [CGColor] = [
            UIColor(hex: "007AFF").cgColor,
            UIColor(hex: "00D4FF").cgColor
        ]
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
        static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let card: CGFloat = 16
    }
    
    // MARK: - Shadows
    struct Shadow {
        static func apply(to layer: CALayer, color: UIColor = .black, opacity: Float = 0.3, radius: CGFloat = 12, offset: CGSize = CGSize(width: 0, height: 4)) {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowRadius = radius
            layer.shadowOffset = offset
        }
    }
}

// MARK: - Theme Alias (for backwards compatibility)
struct Theme {
    static let accentCyan = Design.Colors.accentCyan
    static let accentPink = Design.Colors.accentPink
    static let accentPurple = Design.Colors.accentPurple
    static let success = Design.Colors.success
    static let warning = Design.Colors.warning
    static let error = Design.Colors.error
    static let backgroundPrimary = Design.Colors.backgroundPrimary
    static let backgroundSecondary = Design.Colors.backgroundSecondary
    static let textPrimary = Design.Colors.textPrimary
    static let textSecondary = Design.Colors.textSecondary
    
    struct Gradients {
        static func forApp(_ app: ChatApp) -> [CGColor] {
            return Design.Gradients.forApp(app)
        }
    }
}

// MARK: - UIColor Hex Extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - App Theme Manager
class AppTheme {
    static let shared = AppTheme()
    
    private let defaults = UserDefaults.standard
    private let settingsKey = "app_settings"
    
    var settings: AppSettings {
        get {
            if let data = defaults.data(forKey: settingsKey),
               let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
                return settings
            }
            return .default
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: settingsKey)
            }
        }
    }
    
    var isDarkMode: Bool {
        get { settings.isDarkMode }
        set {
            var s = settings
            s.isDarkMode = newValue
            settings = s
        }
    }
    
    var hapticEnabled: Bool {
        get { settings.hapticEnabled }
        set {
            var s = settings
            s.hapticEnabled = newValue
            settings = s
        }
    }
    
    var defaultApp: ChatApp {
        get { settings.defaultApp }
        set {
            var s = settings
            s.defaultApp = newValue
            settings = s
        }
    }
    
    var defaultWallpaper: WallpaperType {
        get { settings.defaultWallpaper }
        set {
            var s = settings
            s.defaultWallpaper = newValue
            settings = s
        }
    }
    
    var currentBackground: UIColor {
        isDarkMode ? Design.Colors.backgroundPrimary : Design.Colors.lightBackground
    }
    
    var currentCardBackground: UIColor {
        isDarkMode ? Design.Colors.backgroundCard : Design.Colors.lightCard
    }
    
    var currentText: UIColor {
        isDarkMode ? Design.Colors.textPrimary : Design.Colors.lightText
    }
}

// MARK: - Haptic Feedback
extension UIViewController {
    func triggerHaptic() {
        if AppTheme.shared.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}