import UIKit

final class FiltersNavigationController: UINavigationController {
    
    var trackerBuilder: TrackerBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]

        let filtersViewController = FiltersViewController()
        viewControllers = [ filtersViewController ]
    }
}
