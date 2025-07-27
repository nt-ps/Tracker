final class SwitcherCellViewModel {

    // MARK: - Model
    
    private(set) var title: String
    private(set) var value: Any
    private(set) var isOn: Bool
    private var changeAction: ((Any?, Bool) -> Void)?
    
    // MARK: - Initializer
    
    init(title: String, value: Any, isOn: Bool, changeAction: ((Any?, Bool) -> Void)?) {
        self.title = title
        self.value = value
        self.isOn = isOn
        self.changeAction = changeAction
    }
    
    // MARK: - Internal Methods
    
    func updateModel(_ isOn: Bool) {        
        self.isOn = isOn
        changeAction?(value, isOn)
    }
}
