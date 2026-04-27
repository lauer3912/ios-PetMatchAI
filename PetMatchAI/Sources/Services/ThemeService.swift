import UIKit

class ThemeService {
    static let shared = ThemeService()
    
    struct Colors {
        // Primary - Warm orange/coral for pet/friendly feel
        static let primary = UIColor(hex: "#F97316")       // Orange
        static let primaryDark = UIColor(hex: "#EA580C")
        static let secondary = UIColor(hex: "#22C55E")    // Green - adoption/success
        
        // Backgrounds
        static let backgroundLight = UIColor(hex: "#FAFAF9")
        static let backgroundDark = UIColor(hex: "#1C1917")
        static let surfaceLight = UIColor.white
        static let surfaceDark = UIColor(hex: "#292524")
        
        // Text
        static let textPrimaryLight = UIColor(hex: "#1C1917")
        static let textSecondaryLight = UIColor(hex: "#57534E")
        static let textPrimaryDark = UIColor.white
        static let textSecondaryDark = UIColor(hex: "#A8A29E")
        
        // Accent
        static let accent = UIColor(hex: "#3B82F6")        // Blue for links/interactive
        static let error = UIColor(hex: "#EF4444")
        static let warning = UIColor(hex: "#EAB308")
        static let success = UIColor(hex: "#22C55E")
    }
    
    private var isDarkMode: Bool {
        return UserDefaults.standard.string(forKey: "preferredTheme") == "dark" ||
               (UserDefaults.standard.string(forKey: "preferredTheme") != "light" && 
                UITraitCollection.current.userInterfaceStyle == .dark)
    }
    
    func applyTheme() {
        let navBarAppearance = UINavigationBarAppearance()
        if isDarkMode {
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = Colors.surfaceDark
            navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.textPrimaryDark]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.textPrimaryDark]
        } else {
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = Colors.surfaceLight
            navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.textPrimaryLight]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.textPrimaryLight]
        }
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = Colors.primary
        
        // Tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = isDarkMode ? Colors.surfaceDark : Colors.surfaceLight
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = Colors.primary
    }
    
    var backgroundColor: UIColor {
        isDarkMode ? Colors.backgroundDark : Colors.backgroundLight
    }
    
    var surfaceColor: UIColor {
        isDarkMode ? Colors.surfaceDark : Colors.surfaceLight
    }
    
    var textPrimary: UIColor {
        isDarkMode ? Colors.textPrimaryDark : Colors.textPrimaryLight
    }
    
    var textSecondary: UIColor {
        isDarkMode ? Colors.textSecondaryDark : Colors.textSecondaryLight
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