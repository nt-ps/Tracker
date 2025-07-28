final class CheckmarkCellViewModel {
    
    // MARK: - Model
    
    private(set) var title: String
    var value: Any
    private(set) var isSelected: Bool
    private var selectAction: ((Any?) -> Void)?
    
    // MARK: - Initializer
    
    init(title: String, value: Any, isSelected: Bool, selectAction: ((Any?) -> Void)?) {
        self.title = title
        self.value = value
        self.isSelected = isSelected
        self.selectAction = selectAction
    }
    
    // MARK: - Internal Methods
    
    func updateModel(_ isSelected: Bool) {
        self.isSelected = isSelected
        selectAction?(value)
    }
}
