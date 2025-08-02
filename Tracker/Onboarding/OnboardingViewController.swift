import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Views
    
    lazy var pages: [UIViewController] = {
        let firstScreen = OnboardingScreenViewController()
        firstScreen.backgroundImage = UIImage(resource: .Onboarding.firstScreenBackground)
        firstScreen.labelText = "Отслеживайте только то, что хотите"
        let secondScreen = OnboardingScreenViewController()
        secondScreen.backgroundImage = UIImage(resource: .Onboarding.secondScreenBackground)
        secondScreen.labelText = "Даже если это не литры воды и йога"
        return [firstScreen, secondScreen]
    } ()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .AppColors.black
        pageControl.pageIndicatorTintColor = .AppColors.black.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var doneButton: SolidButton = {
        let doneButton = SolidButton()
        doneButton.setTitle("Вот это технологии!", for: .normal)
        doneButton.addTarget(
            self,
            action: #selector(didTapDoneButton),
            for: .touchUpInside
        )
        return doneButton
    } ()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .AppColors.white
        
        view.addSubview(pageControl)
        view.addSubview(doneButton)
        setConstraints()
        
        delegate = self
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapDoneButton() {
        guard let window = view.window?.windowScene?.keyWindow else {
            assertionFailure("[\(#function)] Invalid Configuration.")
            return
        }

        let mainTabBarController = MainTabBarController()
        window.rootViewController = mainTabBarController
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            doneButton.topAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor
            ),
            doneButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            doneButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -50
            ),
            
            pageControl.topAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor
            ),
            pageControl.bottomAnchor.constraint(
                equalTo: doneButton.topAnchor,
                constant: -24
            ),
            pageControl.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor,
            )
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let viewControllerIndex = pages.firstIndex(of: viewController)
        else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1 < 0 ? pages.count - 1 : viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let viewControllerIndex = pages.firstIndex(of: viewController)
        else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1 < pages.count ? viewControllerIndex + 1 : 0

        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
       if let currentViewController = pageViewController.viewControllers?.first,
          let currentIndex = pages.firstIndex(of: currentViewController) {
           pageControl.currentPage = currentIndex
       }
   }
}
