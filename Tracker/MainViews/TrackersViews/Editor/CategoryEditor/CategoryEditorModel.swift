final class CategoryEditorModel {
    // MARK: - Category Data
    
    private(set) var title: String?
    
    // MARK: - Private Properties
    
    private let requiredTitleLength = 38
    
    // MARK: - Initializers
    
    init(for categoryTitle: String? = nil) {
        self.title = categoryTitle
    }
    
    // MARK: - Internal Methods
    
    func didTitleEnter(_ name: String?) -> Result<Void, Error> {
        do {
            try validate(name: name)
        } catch {
            self.title = nil
            return .failure(error)
        }

        self.title = name
        
        return .success(())
    }
    
    func validate() -> Bool {
        guard let title else { return false }
        return !title.isEmpty
    }
    
    // MARK: - Private Methods
    
    private func validate(name string: String?) throws {
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
