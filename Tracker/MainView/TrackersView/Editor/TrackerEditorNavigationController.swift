import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    
    weak var trackersNavigator: TrackersNavigatorItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersNavigator = self.trackersNavigator
        self.viewControllers = [ trackerTypeViewController ]
        
    }
}
