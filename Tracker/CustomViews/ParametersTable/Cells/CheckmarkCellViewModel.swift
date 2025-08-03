final class CheckmarkCellViewModel {
    
    // MARK: - Model
    
    private(set) var title: String
    var value: Any
    private(set) var isSelected: Bool
    private var selectAction: ((Any?) -> Void)?
    private var deleteAction: ((Any?) -> Void)?
    private var editAction: ((Any?) -> Void)?
    
    // MARK: - Initializer
    
    init(
        title: String,
        value: Any,
        isSelected: Bool,
        selectAction: ((Any?) -> Void)? = nil,
        deleteAction: ((Any?) -> Void)? = nil,
        editAction: ((Any?) -> Void)? = nil,
    ) {
        self.title = title
        self.value = value
        self.isSelected = isSelected
        self.selectAction = selectAction
        self.deleteAction = deleteAction
        self.editAction = editAction
    }
    
    // MARK: - Internal Methods
    
    func updateModel(_ isSelected: Bool) {
        self.isSelected = isSelected
        selectAction?(value)
    }
    
    func delete() {
        deleteAction?(value)
    }
    
    func edit() {
        editAction?(value)
    }
}
