import UIKit

final class TrackerTypeViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, eventButton])
        stackView.axis = .vertical
        stackView.spacing = 16.0 // TODO: Вычислять относительно базовой единицы.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    } ()
    
    private lazy var habitButton: UISolidButton = {
        let habitButton = UISolidButton()
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.addTarget(
            self,
            action: #selector(self.didTapHabitButton),
            for: .touchUpInside
        )
        return habitButton
    } ()
    
    private lazy var eventButton: UISolidButton = {
        let eventButton = UISolidButton()
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.addTarget(
            self,
            action: #selector(self.didTapEventButton),
            for: .touchUpInside
        )
        return eventButton
    } ()
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание трекера"
        
        view.addSubview(stackView)
        
        
        setConstraints()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapHabitButton() { }

    @objc
    private func didTapEventButton() { }
    
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
