import UIKit

class ThemeService {
    static let shared = ThemeService()
    
    struct Colors {
        // Primary - Warm orange/coral for pet/friendly feel
        let primary = UIColor(hex: "#F97316")       // Orange
        let primaryDark = UIColor(hex: "#EA580C")
        let secondary = UIColor(hex: "#22C55E")    // Green - adoption/success
        
        // Backgrounds
        let backgroundLight = UIColor(hex: "#FAFAF9")
        let backgroundDark = UIColor(hex: "#1C1917")
        let surfaceLight = UIColor.white
        let surfaceDark = UIColor(hex: "#292524")
        
        // Text
        let textPrimaryLight = UIColor(hex: "#1C1917")
        let textSecondaryLight = UIColor(hex: "#57534E")
        let textPrimaryDark = UIColor.white
        let textSecondaryDark = UIColor(hex: "#A8A29E")
        
        // Accent
        let accent = UIColor(hex: "#3B82F6")        // Blue for links/interactive
        let error = UIColor(hex: "#EF4444")
        let warning = UIColor(hex: "#EAB308")
        let success = UIColor(hex: "#22C55E")
    }
    
    var colors = Colors()
    
    private var isDarkMode: Bool {
        return UserDefaults.standard.string(forKey: "preferredTheme") == "dark" ||
               (UserDefaults.standard.string(forKey: "preferredTheme") != "light" && 
                UITraitCollection.current.userInterfaceStyle == .dark)
    }
    
    func applyTheme() {
        let navBarAppearance = UINavigationBarAppearance()
        if isDarkMode {
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = colors.surfaceDark
            navBarAppearance.titleTextAttributes = [.foregroundColor: colors.textPrimaryDark]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: colors.textPrimaryDark]
        } else {
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = colors.surfaceLight
            navBarAppearance.titleTextAttributes = [.foregroundColor: colors.textPrimaryLight]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: colors.textPrimaryLight]
        }
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = colors.primary
        
        // Tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = isDarkMode ? colors.surfaceDark : colors.surfaceLight
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = colors.primary
    }
    
    var backgroundColor: UIColor {
        isDarkMode ? colors.backgroundDark : colors.backgroundLight
    }
    
    var surfaceColor: UIColor {
        isDarkMode ? colors.surfaceDark : colors.surfaceLight
    }
    
    var textPrimary: UIColor {
        isDarkMode ? colors.textPrimaryDark : colors.textPrimaryLight
    }
    
    var textSecondary: UIColor {
        isDarkMode ? colors.textSecondaryDark : colors.textSecondaryLight
    }
}

// MARK: - UIColor Hex Extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
