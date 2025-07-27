final class TypeEditorViewModel {
    
    // MARK: - Bindings
    
    var onTypeSelectedStateChange: Action?
    
    // MARK: - Tracker Editor View Model
    
    let trackerEditorViewModel: TrackerEditorViewModel
    
    // MARK: - Initializers
    
    init(from trackerEditorViewModel: TrackerEditorViewModel) {
        self.trackerEditorViewModel = trackerEditorViewModel
    }
    
    // MARK: - Internal Methods
    
    func setHabitType() {
        trackerEditorViewModel.setHabitType()
        onTypeSelectedStateChange?()
    }
    
    func setEventType() {
        trackerEditorViewModel.setEventType()
        onTypeSelectedStateChange?()
    }
}
