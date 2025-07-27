import UIKit

final class CategoryEditorViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var titleTextField: OneLineTextField = {
        let titleTextField = OneLineTextField()
        titleTextField.placeholder = "Введите название категории"
        titleTextField.text = viewModel?.categoryTitle
        titleTextField.editingAction = titleDidChange
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
    // var categoryTitle: String? { titleTextField.text }
    
    // MARK: - View Model
    
    private var viewModel: CategoryEditorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewModel?.editorTitle
        navigationItem.setHidesBackButton(true, animated: true)

        view.addSubview(titleTextField)
        view.addSubview(createButton)
        setConstraints()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: CategoryEditorViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onTitleErrorStateChange = { [weak self] message in
            self?.setTitleError(message)
        }
        
        viewModel.onCategoryCreationAllowedStateChange = { [weak self] isCreationAllowed in
            self?.setCreateButton(enabled: isCreationAllowed)
        }
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapCreateButton() {
        guard let viewModel, let title = titleTextField.text else { return }
        viewModel.addCategory()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Updates
    
    private func setTitleError(_ message: String?) {
        titleTextField.message = message
    }
    
    private func setCreateButton(enabled: Bool) {
        createButton.isEnabled = enabled
    }
    
    private func titleDidChange() {
        viewModel?.didTitleEnter(titleTextField.text)
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
