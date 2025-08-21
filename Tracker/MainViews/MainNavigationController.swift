import UIKit

final class MainNavigationController: UINavigationController {
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .AppColors.white
        
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        
        if let viewController {
            viewControllers = [ viewController ]
        }
    }
}
