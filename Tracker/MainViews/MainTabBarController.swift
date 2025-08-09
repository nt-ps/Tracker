import UIKit
 
final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .AppColors.white
        
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .AppColors.blue
        
        let trackersNavigationController = MainNavigationController()
        trackersNavigationController.viewController = TrackersNavigationItem()
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("mainTabBar.trackersTitle", comment: "Trackers tab title"),
            image: UIImage(resource: .Icons.trackersTab),
            selectedImage: nil
        )
        
        let statisticsNavigationController = MainNavigationController()
        statisticsNavigationController.viewController = StatisticsNavigationItem()
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("mainTabBar.statisticsTitle", comment: "Statistics tab title"),
            image: UIImage(resource: .Icons.statisticsTab),
            selectedImage: nil
        )
        
        viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
}

