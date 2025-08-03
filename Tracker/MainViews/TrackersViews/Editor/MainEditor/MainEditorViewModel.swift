import UIKit

final class MainEditorViewModel {
    
    // MARK: - Bindings
    
    var onTrackerCreationAllowedStateChange: Binding<Bool>?
    var onRecordCounterStateChange: Binding<String?>?
    var onNameStateChange: Binding<String?>?
    var onNameErrorStateChange: Binding<String?>?
    var onCategorySelectionStateChange: Binding<String?>?
    var onScheduleStateChange: Binding<String?>?
    var onEmojiStateChange: Binding<Character?>?
    var onColorStateChange: Binding<UIColor?>?
    
    // MARK: - Internal Properties
    
    var emojiValues: [Character] { TrackerEditorData.emoji }
    var colorValues: [UIColor] { TrackerEditorData.colors }
    
    var mainEditorTitle: String? {
        if model.validate() {
            switch model.type {
            case .habit: NSLocalizedString("mainEditor.editingHabitTitle", comment: "Editing habit title")
            case .event: NSLocalizedString("mainEditor.editingEventTitle", comment: "Editing event title")
            default: ""
            }
        } else {
            switch model.type {
            case .habit: NSLocalizedString("mainEditor.newHabitTitle", comment: "New habit title")
            case .event: NSLocalizedString("mainEditor.newEventTitle", comment: "New event title")
            default: ""
            }
        }
    }
    
    var saveButtonTitle: String? {
        return model.validate()
            ? NSLocalizedString("saveButtonTitle", comment: "Save button title")
            : NSLocalizedString("createButtonTitle", comment: "Create button title")
    }
    
    var isScheduleAvailable: Bool {
        switch model.type {
        case .habit: true
        default: false
        }
    }
    
    var showRecordCounter: Bool { model.validate() }
    
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
    
    func saveTracker() {
        // TODO: В будущем пробросить ошибки.
        guard
            let tracker = try? model.getTracker(),
            let category = model.category
        else { return }
        
        try? trackersSource.saveTracker(tracker, to: category)
    }
    
    func updateData() {
        onRecordCounterStateChange?(String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of days marked"),
            model.recordsNum ?? 0
        ))
        onNameStateChange?(model.name)
        onCategorySelectionStateChange?(model.category)
        if case .habit(let schedule) = model.type {
            onScheduleStateChange?(schedule.toString())
        }
        onEmojiStateChange?(model.emoji)
        onColorStateChange?(model.color)
        
        validate()
    }
    
    // MARK: - Private Methods
    
    private func validate() {
        let isCreationAllowed = model.validate()
        onTrackerCreationAllowedStateChange?(isCreationAllowed)
    }
}
