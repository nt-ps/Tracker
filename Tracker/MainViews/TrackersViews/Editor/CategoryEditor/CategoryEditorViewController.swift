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
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [createButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
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
    
    // MARK: - UI Properties
    
    private let textFieldXSpacing = 16.0
    private let textFieldYSpacing = 24.0
    
    private let buttonsXSpacing = 20.0
    private let buttonsTopSpacing = 8.0
    private let buttonsBottomSpacing = ScreenType.shared.isWithIsland ? 16.0 : 24.0
    private let buttonsHeight = 68.0
    
    // MARK: - View Model
    
    private var viewModel: CategoryEditorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewModel?.editorTitle
        navigationItem.setHidesBackButton(true, animated: true)

        view.addSubview(titleTextField)
        view.addSubview(buttonsStackView)
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
            self?.titleTextField.message = message
        }
        
        viewModel.onCategoryCreationAllowedStateChange = { [weak self] isCreationAllowed in
            self?.createButton.isEnabled = isCreationAllowed
        }
    }
    
    // MARK: - UI Actions
    
    @objc
    private func didTapCreateButton() {
        viewModel?.addCategory()
        navigationController?.popViewController(animated: true)
    }
    
    private func titleDidChange() {
        viewModel?.didTitleEnter(titleTextField.text)
    }
    
    // MARK: - UI Updates

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: textFieldXSpacing
            ),
            titleTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: textFieldYSpacing
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -textFieldXSpacing
            ),
            titleTextField.bottomAnchor.constraint(
                lessThanOrEqualTo: createButton.topAnchor
            ),
            
            buttonsStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: buttonsXSpacing
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -buttonsXSpacing
            ),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -buttonsBottomSpacing
            ),
            buttonsStackView.heightAnchor.constraint(
                equalToConstant: buttonsHeight
            ),
            
            createButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: buttonsTopSpacing
            )
        ])
    }
}
