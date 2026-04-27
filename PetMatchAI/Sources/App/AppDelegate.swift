import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        // Start with onboarding flow
        let hasCompletedQuiz = UserDefaults.standard.bool(forKey: "hasCompletedQuiz")
        
        if hasCompletedQuiz {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        }
        
        window?.makeKeyAndVisible()
        
        // Apply theme
        ThemeService.shared.applyTheme()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ThemeService.shared.applyTheme()
    }
}