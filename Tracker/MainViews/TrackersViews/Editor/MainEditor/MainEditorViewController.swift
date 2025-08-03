import UIKit

final class MainEditorViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    } ()
    
    private lazy var parametersStackView: UIStackView = {
        let parametersStackView = UIStackView(
            arrangedSubviews: [
                nameTextField,
                parametersTableView,
                emojiCollectionView,
                colorCollectionView
            ]
        )
        parametersStackView.axis = .vertical
        parametersStackView.spacing = stackItemYSpacing
        parametersStackView.translatesAutoresizingMaskIntoConstraints = false
        parametersStackView.isLayoutMarginsRelativeArrangement = true
        return parametersStackView
    } ()
    
    private lazy var nameTextField: OneLineTextField = {
        let nameTextField = OneLineTextField()
        nameTextField.placeholder = NSLocalizedString(
            "mainEditor.nameFieldPlaceholder",
            comment: "Instruction to action with text field"
        )
        nameTextField.editingAction = nameDidChange
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    } ()
    
    private lazy var parametersTableView: ParametersTableView = {
        let parametersTableView = ParametersTableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters = [categoryButton]
        if let viewModel, viewModel.isScheduleAvailable {
            parameters.append(scheduleButton)
        }
        parametersTableView.updateParameters(parameters)
        return parametersTableView
    } ()

    private lazy var categoryButton: ButtonCellView = {
        let categoryButton = ButtonCellView()
        categoryButton.title = NSLocalizedString(
            "mainEditor.categoryButtonTitle",
            comment: "Category button title"
        )
        categoryButton.tapAction = showCategories
        return categoryButton
    } ()
    
    private lazy var scheduleButton: ButtonCellView = {
        let scheduleButton = ButtonCellView()
        scheduleButton.title = NSLocalizedString(
            "mainEditor.scheduleButtonTitle",
            comment: "Schedule button title"
        )
        scheduleButton.tapAction = showScheduleEditor
        return scheduleButton
    } ()
    
    private lazy var emojiCollectionView: SelectorCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = SelectorCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        emojiCollectionView.title = NSLocalizedString(
            "mainEditor.emojiCollectionTitle",
            comment: "Emoji сollection title"
        )
        emojiCollectionView.addValues(viewModel?.emojiValues)
        emojiCollectionView.selectionAction = emojiDidChange
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    } ()
    
    private lazy var colorCollectionView: SelectorCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colorCollectionView = SelectorCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        colorCollectionView.title = NSLocalizedString(
            "mainEditor.colorCollectionTitle",
            comment: "Color collection title"
        )
        colorCollectionView.addValues(viewModel?.colorValues)
        colorCollectionView.selectionAction = colorDidChange
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return colorCollectionView
    } ()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    } ()
    
    private lazy var cancelButton: OutlineButton = {
        let cancelButton = OutlineButton()
        let buttonTitle = NSLocalizedString("cancelButtonTitle", comment: "Cancel button title")
        cancelButton.setTitle(buttonTitle, for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )
        return cancelButton
    } ()
    
    private lazy var createButton: SolidButton = {
        let createButton = SolidButton()
        let buttonTitle = NSLocalizedString("createButtonTitle", comment: "Create button title")
        createButton.setTitle(buttonTitle, for: .normal)
        createButton.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        createButton.isEnabled = false
        return createButton
    } ()
    
    // MARK: - UI Properties
    
    private let stackItemXSpacing = 16.0
    private let stackItemYSpacing = 24.0
    
    private let buttonsXSpacing = 20.0
    private let buttonsTopSpacing = 8.0
    private let buttonsBottomSpacing = ScreenType.shared.isWithIsland ? 0.0 : 24.0
    private let buttonsHeight = 68.0
    
    // MARK: - View Model
    
    private var viewModel: MainEditorViewModel?
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewModel?.mainEditorTitle
        navigationItem.setHidesBackButton(true, animated: true)

        scrollView.addSubview(parametersStackView)
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        setConstraints()
        
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: MainEditorViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onTrackerCreationAllowedStateChange = { [weak self] isCreationAllowed in
            self?.createButton.isEnabled = isCreationAllowed
        }
        
        viewModel.onNameErrorStateChange = { [weak self] message in
            self?.nameTextField.message = message
        }
        
        viewModel.onCategorySelectionStateChange = { [weak self] category in
            guard let self else { return }
            self.categoryButton.subtitle = category
            self.navigationController?.popToViewController(self, animated: true)
        }
        
        viewModel.onScheduleStateChange = { [weak self] schedule in
            self?.scheduleButton.subtitle = schedule
        }
    }
    
    // MARK: - UI Actions
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true) { }
    }
    
    @objc
    private func didTapCreateButton() {
        viewModel?.addTracker()
        dismiss(animated: true)
    }
    
    private func nameDidChange() {
        viewModel?.didNameEnter(nameTextField.text)
    }
    
    private func emojiDidChange() {
        let value = emojiCollectionView.selectedValue as? Character
        viewModel?.emojiDidChange(value)
    }
    
    private func colorDidChange() {
        let value = colorCollectionView.selectedValue as? UIColor
        viewModel?.colorDidChange(value)
    }
    
    // MARK: - UI Updates
    
    private func showScheduleEditor() {
        guard let viewModel else { return }
        
        let scheduleEditorViewController = ScheduleEditorViewController()
        
        let scheduleEditorViewModel = viewModel.scheduleEditorViewModel
        scheduleEditorViewController.setViewModel(scheduleEditorViewModel)
        
        navigationController?.pushViewController(scheduleEditorViewController, animated: true)
    }
    
    private func showCategories() {
        guard let viewModel else { return }
        
        let categoriesViewController = CategorySelectorViewController()
        
        let categoriesViewModel = viewModel.categorySelectorViewModel
        categoriesViewController.setViewModel(categoriesViewModel)
        
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }

    private func setConstraints() {
        let emojiCollectionViewHeight = emojiCollectionView.estimatHeight(for: view.bounds)
        let colorCollectionViewHeight = colorCollectionView.estimatHeight(for: view.bounds)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            parametersStackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: stackItemYSpacing
            ),
            parametersStackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -stackItemYSpacing
            ),
            parametersStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: stackItemXSpacing
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -stackItemXSpacing
            ),
            
            parametersTableView.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: stackItemXSpacing
            ),
            parametersTableView.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -stackItemXSpacing
            ),
            
            emojiCollectionView.topAnchor.constraint(
                equalTo: parametersTableView.bottomAnchor,
                constant: 20
            ),
            emojiCollectionView.leadingAnchor.constraint(
                equalTo: parametersTableView.leadingAnchor,
                constant: -stackItemXSpacing
            ),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: emojiCollectionViewHeight),
            
            colorCollectionView.topAnchor.constraint(
                equalTo: emojiCollectionView.bottomAnchor
            ),
            colorCollectionView.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor
            ),
            colorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: colorCollectionViewHeight),
            
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
            
            cancelButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: buttonsTopSpacing
            ),
            
            createButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: buttonsTopSpacing
            )
        ])
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: view,
            action: #selector(view.endEditing)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
