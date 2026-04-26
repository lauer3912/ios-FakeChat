import UIKit

class MainTabBarController: UITabBarController {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.circle"), tag: 0)
        
        let templatesVC = UINavigationController(rootViewController: TemplatesViewController())
        templatesVC.tabBarItem = UITabBarItem(title: "Templates", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 2)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        
        viewControllers = [homeVC, templatesVC, historyVC, settingsVC]
    }
    
    private func setupAppearance() {
        // Tab bar blur background
        tabBar.backgroundColor = .clear
        tabBar.insertSubview(blurView, at: 0)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Tint color
        tabBar.tintColor = Design.cyan
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = Design.cyan
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Design.cyan]
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}