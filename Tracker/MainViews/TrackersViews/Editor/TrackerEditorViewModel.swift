import UIKit

final class TrackerEditorViewModel {
    
    // MARK: - Bindings
    
    var onTrackerCreationAllowedStateChange: Binding<Bool>?
    var onNameErrorStateChange: Binding<String?>?
    var onCategorySelectionStateChange: Binding<String?>?
    var onScheduleStateChange: Binding<String?>?
    
    // MARK: - Data Sources
    
    var mainEditorTitle: String? {
        switch model.type {
        case .habit: "Новая привычка"
        case .event: "Новое нерегулярное событие"
        default: ""
        }
    }
    
    var isScheduleAvailable: Bool {
        switch model.type {
        case .habit: true
        default: false
        }
    }
    
    // TODO: Проверить, возможно не понадобится.
    // Так как идет повтор с [WeekDay].
    var schedule: Schedule? {
        switch model.type {
        case .habit(let schedule): schedule
        default: nil
        }
    }
    
    var days: [WeekDay] { schedule?.days ?? [] }
    
    var selectedCategory: String? { model.category }
    
    // MARK: - Trackers Source
    
    private var trackersSource: TrackersSourceProtocol
    
    // MARK: - Model
    
    private let model: TrackerEditorModel
    
    // MARK: - Initializers
    
    init(
        for model: TrackerEditorModel,
        with trackersSource: TrackersSourceProtocol
    ) {
        self.model = model
        self.trackersSource = trackersSource
    }
    
    // MARK: - Internal Methods
    
    func setHabitType() {
        let schedule = Schedule();
        let type = TrackerType.habit(schedule)
        model.setType(type)
        
        validate()
    }
    
    func setEventType() {
        let type = TrackerType.event
        model.setType(type)
        
        validate()
    }
    
    func didNameEnter(_ name: String?) {
        let result = model.didNameEnter(name)
        
        switch result {
        case .success:
            onNameErrorStateChange?(nil)
        case .failure(let error):
            if let error = error as? TrackerEditorError {
                onNameErrorStateChange?(error.localizedDescription)
            }
        }
        
        validate()
    }
    
    func categoryDidSelected(_ category: String?) {
        model.setCategory(category)
        onCategorySelectionStateChange?(category)
        validate()
    }
    
    func updateSchedule(_ day: WeekDay, included: Bool) {
        model.updateSchedule(day, included: included)
        onScheduleStateChange?(model.schedule?.toString())
        validate()
    }
    
    func emojiDidChange(_ emoji: Character?) {
        model.setEmoji(emoji)
        validate()
    }
    
    func colorDidChange(_ color: UIColor?) {
        model.setColor(color)
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
