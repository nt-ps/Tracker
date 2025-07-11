import UIKit

final class TrackerTypeViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, eventButton])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var habitButton: SolidButton = {
        let habitButton = SolidButton()
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.addTarget(
            self,
            action: #selector(didTapHabitButton),
            for: .touchUpInside
        )
        return habitButton
    } ()
    
    private lazy var eventButton: SolidButton = {
        let eventButton = SolidButton()
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.addTarget(
            self,
            action: #selector(didTapEventButton),
            for: .touchUpInside
        )
        return eventButton
    } ()
    
    // MARK: - Internal Properties
    
    weak var trackersNavigationItem: TrackersNavigationItem?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание трекера"
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(stackView)
        
        setConstraints()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapHabitButton() {
        let trackerEditorViewController = TrackerEditorViewController()
        trackerEditorViewController.trackersNavigator = trackersNavigationItem
        trackerEditorViewController.trackerType = .habit(Schedule())
        trackerEditorViewController.viewTitle = "Новая привычка"
        navigationController?.pushViewController(trackerEditorViewController, animated: true)
    }

    @objc
    private func didTapEventButton() {
        let trackerEditorViewController = TrackerEditorViewController()
        trackerEditorViewController.trackersNavigator = trackersNavigationItem
        trackerEditorViewController.trackerType = .event
        trackerEditorViewController.viewTitle = "Новое нерегулярное событие"
        navigationController?.pushViewController(trackerEditorViewController, animated: true)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            )
        ])
    }
}
