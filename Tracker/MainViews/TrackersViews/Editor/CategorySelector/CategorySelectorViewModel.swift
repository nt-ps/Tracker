final class CategorySelectorViewModel {
    
    // MARK: - Bindings

    var onCategorySelectionStateChange: Binding<String?>?
    var onCategoriesListStateChange: Binding<[CheckmarkCellViewModel]>?
    var onCategoryEditStateChange: Binding<CategoryEditorViewModel>?
    
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
                },
                deleteAction: { [weak self] value in
                    guard let category = value as? String else { return }
                    self?.deleteCategory(category)
                },
                editAction: { [weak self] value in
                    guard let self, let category = value as? String else { return }
                    let categoryBuilder = CategoryBuilder(for: category)
                    let categoryEditorViewModel = CategoryEditorViewModel(
                        for: categoryBuilder,
                        categoriesSource: self.categoriesSource
                    )
                    categoryEditorViewModel.onSelectedCategoryStateChange = { [weak self] newTitle in
                        self?.model.category = newTitle
                    }
                    onCategoryEditStateChange?(categoryEditorViewModel)
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
    
    // MARK: - Private Methods
    
    func deleteCategory(_ category: String) {
        try? categoriesSource.deleteCategory(category)
    }
}

extension CategorySelectorViewModel: CategoriesSourceDelegate {
    func didUpdate(_ update: CategoriesSourceUpdate) {
        // TODO: Переписать с добавлением только нового элемента.
        onCategoriesListStateChange?(categories)
    }
}
