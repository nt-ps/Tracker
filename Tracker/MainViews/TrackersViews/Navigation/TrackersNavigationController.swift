import UIKit

final class TrackersNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        
        let trackersNavigationItem = TrackersNavigationItem()
        viewControllers = [ trackersNavigationItem ]
    }
}
