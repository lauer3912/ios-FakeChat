import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        // Home - Create Tab
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Create",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        // Templates Tab
        let templatesVC = TemplatesViewController()
        let templatesNav = UINavigationController(rootViewController: templatesVC)
        templatesNav.tabBarItem = UITabBarItem(
            title: "Templates",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        
        // History Tab
        let historyVC = HistoryViewController()
        let historyNav = UINavigationController(rootViewController: historyVC)
        historyNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.fill")
        )
        
        // Settings Tab
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        viewControllers = [homeNav, templatesNav, historyNav, settingsNav]
    }
    
    private func setupAppearance() {
        // Tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Design.Colors.backgroundSecondary
        
        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = Design.Colors.textSecondary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Design.Colors.textSecondary
        ]
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = Design.Colors.accentCyan
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Design.Colors.accentCyan
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // Navigation bar appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = Design.Colors.backgroundPrimary
        navAppearance.titleTextAttributes = [
            .foregroundColor: Design.Colors.textPrimary
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: Design.Colors.textPrimary
        ]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = Design.Colors.accentCyan
    }
}