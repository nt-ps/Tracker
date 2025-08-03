import UIKit

final class MainEditorViewModel {
    
    // MARK: - Bindings
    
    var onTrackerCreationAllowedStateChange: Binding<Bool>?
    var onNameErrorStateChange: Binding<String?>?
    var onCategorySelectionStateChange: Binding<String?>?
    var onScheduleStateChange: Binding<String?>?
    
    // MARK: - Internal Properties
    
    var emojiValues: [Character] { TrackerEditorData.emoji }
    var colorValues: [UIColor] { TrackerEditorData.colors }
    
    var mainEditorTitle: String? {
        switch model.type {
        case .habit: NSLocalizedString("mainEditor.newHabitEditorTitle", comment: "New habit editor title")
        case .event: NSLocalizedString("mainEditor.newEventEditorTitle", comment: "New event editor title")
        default: ""
        }
    }
    
    var isScheduleAvailable: Bool {
        switch model.type {
        case .habit: true
        default: false
        }
    }
    
    var categorySelectorViewModel: CategorySelectorViewModel {
        let categorySelectorViewModel = CategorySelectorViewModel(for: model)
        categorySelectorViewModel.onCategorySelectionStateChange = { [weak self] category in
            self?.onCategorySelectionStateChange?(category)
            self?.validate()
        }
        return categorySelectorViewModel
    }
    
    var scheduleEditorViewModel: ScheduleEditorViewModel {
        let scheduleEditorViewModel = ScheduleEditorViewModel(for: model)
        scheduleEditorViewModel.onScheduleStateChange = { [weak self] schedule in
            self?.onScheduleStateChange?(schedule)
            self?.validate()
        }
        return scheduleEditorViewModel
    }
    
    // MARK: - Model
    
    private let model: TrackerBuilder
    
    // MARK: - Trackers Source
    
    private var trackersSource: TrackersSourceProtocol
    
    // MARK: - Initializers
    
    init(for model: TrackerBuilder) {
        self.model = model
        self.trackersSource = TrackerStore()
    }
    
    // MARK: - Internal Methods
    
    func didNameEnter(_ name: String?) {
        let result = model.didNameEnter(name)
        
        switch result {
        case .success:
            onNameErrorStateChange?(nil)
        case .failure(let error):
            if let error = error as? TrackerBuilderError {
                onNameErrorStateChange?(error.localizedDescription)
            }
        }
        
        validate()
    }
    
    func emojiDidChange(_ emoji: Character?) {
        model.emoji = emoji
        validate()
    }
    
    func colorDidChange(_ color: UIColor?) {
        model.color = color
        validate()
    }
    
    func addTracker() {
        // TODO: В будущем пробросить ошибки.
        guard
            let tracker = try? model.getTracker(),
            let category = model.category
        else { return }
        
        try? trackersSource.addTracker(tracker, to: category)
    }
    
    // MARK: - Private Methods
    
    private func validate() {
        let isCreationAllowed = model.validate()
        onTrackerCreationAllowedStateChange?(isCreationAllowed)
    }
}
