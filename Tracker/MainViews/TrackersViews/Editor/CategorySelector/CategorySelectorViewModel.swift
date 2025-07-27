final class CategoriesViewModel {
    
    // MARK: - Bindings

    var onCategorySelectionStateChange: Binding<String?>?
    var onCategoriesListStateChange: Binding<[String]>?
    
    // MARK: - Data Source
    
    var categories: [String] { categoriesSource.categories }
    var selectedCategory: String? { model.category }
    
    // MARK: - Internal Properties
    
    var categoryEditorViewModelForCreation: CategoryEditorViewModel {
        let categoryBuilder = CategoryBuilder()
        let categoryEditorViewModel = CategoryEditorViewModel(
            for: categoryBuilder,
            categoriesSource: categoriesSource
        )
        return categoryEditorViewModel
    }

    // MARK: - Model
    
    private let model: TrackerBuilder
    
    // MARK: - Categories Source
    
    private var categoriesSource: CategoriesSourceProtocol
    
    // MARK: - Initializers
    
    init(for model: TrackerBuilder) {
        self.model = model
        self.categoriesSource = TrackerCategoryStore()
        self.categoriesSource.delegate = self
    }
    
    // MARK: - Internal Methods
    
    func categoryDidSelected(_ category: String?) {
        model.category = category
        onCategorySelectionStateChange?(category)
    }
}

extension CategoriesViewModel: CategoriesSourceDelegate {
    func didUpdate(_ update: CategoriesSourceUpdate) {
        // TODO: Переписать не с полным обновлением таблицы, а с добавлением только нового элемента.
        onCategoriesListStateChange?(categories)
    }
}
