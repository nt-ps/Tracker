import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        ScreenType.shared.setHeight(scene.screen.bounds.height)
        window = UIWindow(windowScene: scene)
        if UserDefaultsData.shared.hasLaunchBefore {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            UserDefaultsData.shared.hasLaunchBefore = true
        }
        
        window?.makeKeyAndVisible()
    }
}

