import UIKit

final class TrackersNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.isTranslucent = true
        
        let trackersViewController = TrackersViewController()
        self.viewControllers = [ trackersViewController ]
    }
}
