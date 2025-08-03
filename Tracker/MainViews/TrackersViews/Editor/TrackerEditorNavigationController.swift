import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    
    var trackerBuilder: TrackerBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        if let trackerBuilder {
            let mainEditorViewController = MainEditorViewController()
            let mainEditorViewModel = MainEditorViewModel(for: trackerBuilder)
            mainEditorViewController.setViewModel(mainEditorViewModel)
            viewControllers = [ mainEditorViewController ]
        } else {
            let typeEditorViewController = TypeSelectorViewController()
            let typeEditorViewModel = TypeSelectorViewModel(for: TrackerBuilder())
            typeEditorViewController.setViewModel(typeEditorViewModel)
            viewControllers = [ typeEditorViewController ]
        }
    }
}
