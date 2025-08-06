import UIKit

final class CategorySelectorViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.addSubview(stackView)
        
        return scrollView
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoriesTableView])
        stackView.axis = .vertical
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var categoriesTableView: ParametersTableView = {
        let categoriesTableView = ParametersTableView()
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        categoriesTableView.contextMenu = { [weak self] value in
            UIMenu(children: [
                UIAction(
                    title: NSLocalizedString("editButtonTitle", comment: "Edit button title")
                ) { _ in
                    self?.didTapEditCategoryButton(value)
                },
                UIAction(
                    title: NSLocalizedString("deleteButtonTitle", comment: "Delete button title"),
                    attributes: .destructive
                ) { _ in
                    self?.didTapDeleteCategoryButton(value)
                }
            ])
        }
        return categoriesTableView
    } ()
    
    private lazy var stubView: StubView = {
        let stubView = StubView()
        stubView.labelText = NSLocalizedString(
            "categorySelector.stubText",
            comment: "Display text when list is empty"
        )
        stubView.imageResource = .StubImages.emptyList
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [addCategoryButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    } ()
    
    private lazy var addCategoryButton: SolidButton = {
        let doneButton = SolidButton()
        let buttonTitle = NSLocalizedString(
            "categorySelector.addButtonTitle",
            comment: "Add category button title"
        )
        doneButton.setTitle(buttonTitle, for: .normal)
        doneButton.addTarget(
            self,
            action: #selector(didTapAddCategoryButton),
            for: .touchUpInside
        )
        return doneButton
    } ()
    
    // MARK: - UI Properties
    
    private let stackViewXSpacing = 16.0
    private let stackViewYSpacing = 24.0
    
    private let buttonsXSpacing = 20.0
    private let buttonsTopSpacing = 8.0
    private let buttonsBottomSpacing = ScreenType.shared.isWithIsland ? 16.0 : 24.0
    private let buttonsHeight = 68.0
    
    // MARK: - View Model
    
    private var viewModel: CategorySelectorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString("categorySelector.title", comment: "UI view title")
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(buttonsStackView)
        setConstraints()
        
        updateCategories()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: CategorySelectorViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onCategoriesListStateChange = { [weak self] categories in
            self?.updateCategories(categories)
        }
        
        viewModel.onCategoryEditStateChange = { [weak self] viewModel in
            let categoryEditorViewController = CategoryEditorViewController()
            categoryEditorViewController.setViewModel(viewModel)
            self?.navigationController?.pushViewController(categoryEditorViewController, animated: true)
        }
    }
    
    // MARK: - UI Actions
    
    @objc
    private func didTapAddCategoryButton() {
        guard let viewModel else { return }
        
        let categoryEditorViewController = CategoryEditorViewController()

        let categoryEditorViewModel = viewModel.categoryEditorViewModelForCreation
        categoryEditorViewController.setViewModel(categoryEditorViewModel)
        
        navigationController?.pushViewController(categoryEditorViewController, animated: true)
    }
    
    private func didTapEditCategoryButton(_ sender: Any) {
        guard let cell = sender as? CheckmarkCellView else { return }
        cell.didEdit()
    }
    
    private func didTapDeleteCategoryButton(_ sender: Any) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString(
                "categorySelector.deleteAlertMessage",
                comment: "Delete alert message"
            ),
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("deleteButtonTitle", comment: "Delete button title"),
            style: .destructive
        ) { _ in
            guard let cell = sender as? CheckmarkCellView else { return }
            cell.didDelete()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancelButtonTitle", comment: "Cancel button title"),
            style: .cancel
        )
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - UI Updates
    
    func updateCategories() {
        let categoryCellViewModels = viewModel?.categories
        updateCategories(categoryCellViewModels)
    }
    
    func updateCategories(_ viewModels: [CheckmarkCellViewModel]?) {
        guard
            let viewModels,
            !viewModels.isEmpty
        else {
            showStub()
            return
        }
        
        showCategoriesTableView(with: viewModels)
    }
    
    private func showStub() {
        scrollView.willMove(toSuperview: nil)
        scrollView.removeFromSuperview()
        
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                constant: -buttonsHeight - buttonsBottomSpacing
            )
        ])
    }
    
    private func showCategoriesTableView(with viewModels: [CheckmarkCellViewModel]) {
        stubView.willMove(toSuperview: nil)
        stubView.removeFromSuperview()
        
        categoriesTableView.updateParameters(viewModels)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: stackViewYSpacing
            ),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -stackViewYSpacing
            ),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: stackViewXSpacing
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -stackViewXSpacing
            ),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -stackViewXSpacing * 2
            ),
        ])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
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
            
            addCategoryButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: buttonsTopSpacing
            )
        ])
    }
}
