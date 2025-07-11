import UIKit
 
final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .AppColors.white
        
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .AppColors.blue
        
        let trackersNavigationController = TrackersNavigationController()
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .Icons.trackersTab),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .Icons.statisticsTab),
            selectedImage: nil
        )
        
        viewControllers = [trackersNavigationController, statisticsViewController]
    }
}

