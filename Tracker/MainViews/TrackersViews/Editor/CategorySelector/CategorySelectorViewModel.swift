final class CategoriesViewModel {
    
    // MARK: - Bindings

    var onCategorySelectionStateChange: Binding<String?>?
    var onCategoriesListStateChange: Binding<[CheckmarkCellViewModel]>?
    
    // MARK: - Internal Properties
    
    var categories: [CheckmarkCellViewModel] {
        return categoriesSource.categories.map {
            CheckmarkCellViewModel(
                title: $0,
                value: $0,
                isSelected: $0 == model.category,
                selectAction: { [weak self] value in
                    guard let category = value as? String else { return }
                    self?.categoryDidSelected(category)
                }
            )
        }
    }
    
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
        // TODO: Переписать с добавлением только нового элемента.
        onCategoriesListStateChange?(categories)
    }
}
