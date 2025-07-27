import UIKit

final class MainEditorViewModel {
    
    // MARK: - Bindings
    
    var onTrackerCreationAllowedStateChange: Binding<Bool>? {
        get { trackerEditorViewModel.onTrackerCreationAllowedStateChange }
        set { trackerEditorViewModel.onTrackerCreationAllowedStateChange = newValue }
    }
    var onNameErrorStateChange: Binding<String?>? {
        get { trackerEditorViewModel.onNameErrorStateChange }
        set { trackerEditorViewModel.onNameErrorStateChange = newValue }
    }
    var onCategorySelectionStateChange: Binding<String?>? {
        get { trackerEditorViewModel.onCategorySelectionStateChange }
        set { trackerEditorViewModel.onCategorySelectionStateChange = newValue }
    }
    var onScheduleStateChange: Binding<String?>? {
        get { trackerEditorViewModel.onScheduleStateChange }
        set { trackerEditorViewModel.onScheduleStateChange = newValue }
    }
    
    // MARK: - Data Sources
    
    var emojiValues: [Character] { TrackerViewData.emoji }
    var colorValues: [UIColor] { TrackerViewData.colors }
    
    var mainEditorTitle: String? { trackerEditorViewModel.mainEditorTitle }
    var isScheduleAvailable: Bool { trackerEditorViewModel.isScheduleAvailable }
    var schedule: Schedule? { trackerEditorViewModel.schedule }
    
    // MARK: - Tracker Editor View Model
    
    let trackerEditorViewModel: TrackerEditorViewModel
    
    // MARK: - Initializers
    
    init(from trackerEditorViewModel: TrackerEditorViewModel) {
        self.trackerEditorViewModel = trackerEditorViewModel
    }
    
    // MARK: - Internal Methods
    
    func didNameEnter(_ name: String?) {
        trackerEditorViewModel.didNameEnter(name)
    }
    
    func emojiDidChange(_ emoji: Character?) {
        trackerEditorViewModel.emojiDidChange(emoji)
    }
    
    func colorDidChange(_ color: UIColor?) {
        trackerEditorViewModel.colorDidChange(color)
    }
    
    func addTracker() {
        trackerEditorViewModel.addTracker()
    }
}
