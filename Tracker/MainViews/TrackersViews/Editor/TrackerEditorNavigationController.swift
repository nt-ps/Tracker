import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    
    weak var trackersNavigationItem: TrackersNavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.trackersNavigationItem = trackersNavigationItem
        
        viewControllers = [ trackerTypeViewController ]
    }
}
