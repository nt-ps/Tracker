final class TypeSelectorViewModel {
    
    // MARK: - Bindings
    
    var onTypeSelectedStateChange: Action?
    
    // MARK: - Model
    
    private let model: TrackerBuilder
    
    // MARK: - Internal Properties
    
    var mainEditorViewModel: MainEditorViewModel {
        let mainEditorViewModel = MainEditorViewModel(for: model)
        return mainEditorViewModel
    }
    
    // MARK: - Initializers
    
    init(for model: TrackerBuilder) {
        self.model = model
    }
    
    // MARK: - Internal Methods
    
    func setHabitType() {
        let schedule = Schedule();
        model.type = TrackerType.habit(schedule)
        onTypeSelectedStateChange?()
    }
    
    func setEventType() {
        model.type = TrackerType.event
        onTypeSelectedStateChange?()
    }
}
