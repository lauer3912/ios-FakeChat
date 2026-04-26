import UIKit

class MainTabBarController: UITabBarController {
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
        tabBar.tintColor = UIColor(Theme.accentCyan)
        tabBar.backgroundColor = UIColor(AppTheme.surface)
        tabBar.unselectedItemTintColor = UIColor(AppTheme.textSecondary)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppTheme.surface)
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}