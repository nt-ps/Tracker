import UIKit

final class CategoriesViewController: UIViewController {
    
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
        categoriesTableView.selectionAction = categoryDidSelected
        return categoriesTableView
    } ()
    
    private lazy var stubView: StubView = {
        let stubView = StubView()
        stubView.labelText = "Привычки и события можно\nобъединить по смыслу"
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    private lazy var addCategoryButton: SolidButton = {
        let doneButton = SolidButton()
        doneButton.setTitle("Добавить категорию", for: .normal)
        doneButton.addTarget(
            self,
            action: #selector(didTapAddCategoryButton),
            for: .touchUpInside
        )
        return doneButton
    } ()
    
    // MARK: - View Model
    
    private var viewModel: CategoriesViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Категория"
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(addCategoryButton)
        setConstraints()
        
        updateCategories()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onCategoriesListStateChange = { [weak self] categories in
            self?.updateCategories(categories)
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
    
    private func categoryDidSelected() {
        let value = categoriesTableView.selectedValue as? String
        viewModel?.categoryDidSelected(value)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Updates
    
    func updateCategories() {
        let categories = viewModel?.categories
        updateCategories(categories)
    }
    
    func updateCategories(_ categories: [String]?) {
        guard
            let categories,
            !categories.isEmpty
        else {
            showStub()
            return
        }
        
        showCategoriesTableView(with: categories)
    }
    
    private func showStub() {
        scrollView.willMove(toSuperview: nil)
        scrollView.removeFromSuperview()
        
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                constant: ScreenType.shared.isWithIsland ? -84 : -102 // TODO: Считать центр автоматически с учетом кнопки снизу.
            )
        ])
    }
    
    private func showCategoriesTableView(with categories: [String]) {
        stubView.willMove(toSuperview: nil)
        stubView.removeFromSuperview()
        
        let parameters = categories.map {
            let cell = CheckmarkCellView()
            cell.title = $0
            return cell
        }
        categoriesTableView.selectedValue = viewModel?.selectedCategory
        categoriesTableView.updateParameters(parameters)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: addCategoryButton.topAnchor,
                constant: -8 // TODO: На всех экранах редактора добавить отступ между списком и кнопками!
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 24
            ),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -24
            ),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -16
            ),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -32
            ),
        ])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            addCategoryButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            addCategoryButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: ScreenType.shared.isWithIsland ? -16 : -24 // TODO: На всех экранах редактора сверить отступы кнопок с макетом!
            ),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
