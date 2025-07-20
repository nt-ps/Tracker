import UIKit

final class CategoryEditorViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var titleTextField: OneLineTextField = {
        let titleTextField = OneLineTextField()
        titleTextField.placeholder = "Введите название категории"
        titleTextField.editingAction = updateCreateButton
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    } ()
    
    private lazy var createButton: SolidButton = {
        let createButton = SolidButton()
        createButton.setTitle("Готово", for: .normal)
        createButton.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        createButton.isEnabled = false
        return createButton
    } ()
    
    // MARK: - Private Properties
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Internal Properties
    
    // weak var trackersNavigator: TrackersNavigationItem?
    
    var categoryTitle: String? { titleTextField.text }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Новая категория"
        navigationItem.setHidesBackButton(true, animated: true)

        view.addSubview(titleTextField)
        view.addSubview(createButton)
        setConstraints()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapCreateButton() {
        // TODO: В будущем выводить алерт с ошибкой.
        try? trackerCategoryStore.addCategory(categoryTitle ?? "Без названия")
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Updates
    
    private func updateCreateButton() {
        let isEmpty = categoryTitle?.isEmpty ?? true
        createButton.isEnabled = !isEmpty
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            titleTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            titleTextField.bottomAnchor.constraint(
                lessThanOrEqualTo: createButton.topAnchor
            ),
            
            createButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            createButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            createButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
