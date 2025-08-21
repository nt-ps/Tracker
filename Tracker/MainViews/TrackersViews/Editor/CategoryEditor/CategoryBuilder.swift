final class CategoryBuilder {
    // MARK: - Category Data
    
    private(set) var oldTitle: String?
    private(set) var newTitle: String?
    
    // MARK: - Private Properties
    
    private let requiredTitleLength = 38
    
    // MARK: - Initializers
    
    init(for categoryTitle: String? = nil) {
        self.oldTitle = categoryTitle
        self.newTitle = categoryTitle
    }
    
    // MARK: - Internal Methods
    
    func didTitleEnter(_ title: String?) -> Result<Void, Error> {
        do {
            try validate(title: title)
        } catch {
            self.newTitle = nil
            return .failure(error)
        }

        self.newTitle = title
        
        return .success(())
    }
    
    func validate() -> Bool {
        guard let newTitle else { return false }
        return !newTitle.isEmpty
    }
    
    // MARK: - Private Methods
    
    private func validate(title string: String?) throws {
        guard
            let string,
            !string.isEmpty
        else {
            throw CategoryEditorError.emptyTitle
        }
        
        if string.count > requiredTitleLength {
            throw CategoryEditorError.longTitle(requiredTitleLength)
        }
    }
}
