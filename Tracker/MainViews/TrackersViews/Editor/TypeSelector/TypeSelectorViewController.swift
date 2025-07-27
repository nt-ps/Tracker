import UIKit

final class TypeSelectorViewController: UIViewController {
    
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
    
    // MARK: - View Model
    
    private var viewModel: TypeSelectorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание трекера"
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(stackView)
        
        setConstraints()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: TypeSelectorViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onTypeSelectedStateChange = { [weak self] in
            self?.showMainEditor()
        }
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapHabitButton() {
        viewModel?.setHabitType()
    }

    @objc
    private func didTapEventButton() {
        viewModel?.setEventType()
    }
    
    // MARK: - UI Updates
    
    private func showMainEditor() {
        guard let viewModel else { return }
        
        let mainEditorViewController = MainEditorViewController()
        
        let mainEditorViewModel = viewModel.mainEditorViewModel
        mainEditorViewController.setViewModel(mainEditorViewModel)
        
        navigationController?.pushViewController(mainEditorViewController, animated: true)
    }
    
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
