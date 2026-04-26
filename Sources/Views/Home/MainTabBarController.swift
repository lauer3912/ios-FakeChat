import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.circle.fill"), tag: 0)
        
        let templatesVC = UINavigationController(rootViewController: TemplatesViewController())
        templatesVC.tabBarItem = UITabBarItem(title: "Templates", image: UIImage(systemName: "rectangle.grid.2x2.fill"), tag: 1)
        
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock.fill"), tag: 2)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)
        
        viewControllers = [homeVC, templatesVC, historyVC, settingsVC]
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        tabBar.backgroundColor = UIColor(hex: "0A0A0A")
        tabBar.barTintColor = UIColor(hex: "0A0A0A")
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        tabBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "0A0A0A")
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: .white]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}