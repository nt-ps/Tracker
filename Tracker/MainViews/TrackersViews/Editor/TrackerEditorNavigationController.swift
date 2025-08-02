import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let typeEditorViewController = TypeSelectorViewController()
        
        let trackerBuilder = TrackerBuilder()
        let typeEditorViewModel = TypeSelectorViewModel(for: trackerBuilder)
        typeEditorViewController.setViewModel(typeEditorViewModel)
        
        viewControllers = [ typeEditorViewController ]
    }
}
