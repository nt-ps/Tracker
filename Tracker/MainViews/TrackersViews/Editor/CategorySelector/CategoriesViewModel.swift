final class CategoriesViewModel {
    
    // MARK: - Bindings

    var onCategoriesListStateChange: Binding<[String]>?
    
    // MARK: - Data Source
    
    var categories: [String] { categoriesSource.categories }
    var selectedCategory: String? { trackerEditorViewModel.selectedCategory }

    // MARK: - Models
    
    let trackerEditorViewModel: TrackerEditorViewModel
    var categoriesSource: CategoriesSourceProtocol
    
    // MARK: - Initializers
    
    init(
        from trackerEditorViewModel: TrackerEditorViewModel,
        with categoriesSource: CategoriesSourceProtocol
    ) {
        self.trackerEditorViewModel = trackerEditorViewModel
        self.categoriesSource = categoriesSource
        self.categoriesSource.delegate = self
    }
    
    // MARK: - Internal Methods
    
    func categoryDidSelected(_ category: String?) {
        trackerEditorViewModel.categoryDidSelected(category)
    }
}

extension CategoriesViewModel: CategoriesSourceDelegate {
    func didUpdate(_ update: CategoriesSourceUpdate) {
        // TODO: Переписать не с полным обновлением таблицы, а с добавлением только нового элемента.
        onCategoriesListStateChange?(categories)
    }
}
