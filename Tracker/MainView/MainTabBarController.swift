import UIKit
 
final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .AppColors.white
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.tintColor = .AppColors.blue
        
        let trackersNavigationController = TrackersNavigationController()
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Icons/TrackersTab"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Icons/StatisticsTab"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersNavigationController, statisticsViewController]
    }
}

