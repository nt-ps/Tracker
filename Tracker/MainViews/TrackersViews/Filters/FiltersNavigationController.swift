import UIKit

final class FiltersNavigationController: UINavigationController {
    
    var viewModel: FiltersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]

        let filtersViewController = FiltersViewController()
        if let viewModel {
            filtersViewController.setViewModel(viewModel)
        }
        viewControllers = [ filtersViewController ]
    }
}
