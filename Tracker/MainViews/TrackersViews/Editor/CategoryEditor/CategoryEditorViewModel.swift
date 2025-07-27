final class CategoryEditorViewModel {
    
    // MARK: - Bindings
    
    var onCategoryCreationAllowedStateChange: Binding<Bool>?
    var onTitleErrorStateChange: Binding<String?>?
    
    // MARK: - Data Sources
    
    var categories: [String] { categoriesSource.categories }
    var editorTitle: String {
        model.title == nil ? "Новая категория" : "Редактирование категории"
    }
    var categoryTitle: String? { model.title }
    
    // MARK: - Categories Source
    
    private var categoriesSource: CategoriesSourceProtocol
    
    // MARK: - Model
    
    private let model: CategoryBuilder
    
    // MARK: - Initializers
    
    init(
        for model: CategoryBuilder,
        categoriesSource: CategoriesSourceProtocol
    ) {
        self.model = model
        self.categoriesSource = categoriesSource
    }
    
    // MARK: - Internal Methods
    
    func didTitleEnter(_ name: String?) {
        let result = model.didTitleEnter(name)
        
        switch result {
        case .success:
            onTitleErrorStateChange?(nil)
        case .failure(let error):
            if let error = error as? CategoryEditorError {
                onTitleErrorStateChange?(error.localizedDescription)
            }
        }
        
        validate()
    }
    
    func addCategory() {
        guard let categoryTitle else { return }
        try? categoriesSource.addCategory(categoryTitle) // TODO: В будущем пробросить ошибку.
    }
    
    // MARK: - Private Methods
    
    private func validate() {
        let isCreationAllowed = model.validate()
        onCategoryCreationAllowedStateChange?(isCreationAllowed)
    }
}
