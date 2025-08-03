import Foundation

final class CategoryEditorViewModel {
    
    // MARK: - Bindings
    
    var onCategoryCreationAllowedStateChange: Binding<Bool>?
    var onSelectedCategoryStateChange: Binding<String>?
    var onTitleErrorStateChange: Binding<String?>?
    
    // MARK: - Data Sources
    
    var categories: [String] { categoriesSource.categories }
    var editorTitle: String {
        model.newTitle == nil
            ? NSLocalizedString("categoryEditor.newCategoryTitle", comment: "New category title")
            : NSLocalizedString("categoryEditor.editCategoryTitle", comment: "Edit category title")
    }
    var categoryTitle: String? { model.newTitle }
    
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
    
    func updateCategory() {
        guard let categoryTitle else { return }
        
        // TODO: В будущем пробросить ошибки.
        if let oldTitle = model.oldTitle {
            onSelectedCategoryStateChange?(categoryTitle)
            try? categoriesSource.updateCategory(oldTitle, newTitle: categoryTitle)
        } else {
            try? categoriesSource.addCategory(categoryTitle)
        }
    }
    
    // MARK: - Private Methods
    
    private func validate() {
        let isCreationAllowed = model.validate()
        onCategoryCreationAllowedStateChange?(isCreationAllowed)
    }
}
