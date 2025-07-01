import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationBar.prefersLargeTitles = true
        // self.navigationBar.backgroundColor = .clear
        // self.navigationBar.isTranslucent = true
        
        self.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let trackerTypeViewController = TrackerTypeViewController()
        self.viewControllers = [ trackerTypeViewController ]
        
    }
}
