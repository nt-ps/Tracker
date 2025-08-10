import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMainTabBarController() {
        let mainTabBarController = MainTabBarController()
        assertSnapshot(of: mainTabBarController, as: .image)
    }
    
    func testStatisticsNavigationItem() {
        let mainTabBarController = MainTabBarController()
        guard
            let statisticsNavigationItem = mainTabBarController.viewControllers?[1]
        else { return }
        assertSnapshot(of: statisticsNavigationItem, as: .image)
    }
}
