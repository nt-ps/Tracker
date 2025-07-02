import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let trackerTypeViewController = TrackerTypeViewController()
        self.viewControllers = [ trackerTypeViewController ]
        
    }
}
