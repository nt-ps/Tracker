import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMainTabBarController() {
        let mainTabBarController = MainTabBarController()
        assertSnapshot(of: mainTabBarController, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: mainTabBarController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testStatisticsNavigationItem() {
        let mainTabBarController = MainTabBarController()
        guard
            let statisticsNavigationItem = mainTabBarController.viewControllers?[1]
        else { return }
        assertSnapshot(of: statisticsNavigationItem, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: statisticsNavigationItem, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
