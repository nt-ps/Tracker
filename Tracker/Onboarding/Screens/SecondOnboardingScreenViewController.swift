import UIKit

final class SecondOnboardingScreenViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var backgroundView: UIImageView = {
        let background = UIImage(resource: backgroundResource)
        let backgroundView = UIImageView(image: background)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    } ()
    
    private lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = labelText
        labelView.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        labelView.textColor = .AppColors.black
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 3
        labelView.textAlignment = .center
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    } ()
    
    // MARK: - UI Properties
    
    private let backgroundResource: ImageResource = .Onboarding.secondScreenBackground
    private let labelText = "Даже если это не литры воды и йога"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.addSubview(labelView)
        setConstraints()
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                constant: ScreenType.shared.isWithIsland ? 60 : 16
            )
        ])
    }
}
