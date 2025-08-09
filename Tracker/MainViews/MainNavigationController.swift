import UIKit

final class MainNavigationController: UINavigationController {
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        
        if let viewController {
            viewControllers = [ viewController ]
        }
    }
}
