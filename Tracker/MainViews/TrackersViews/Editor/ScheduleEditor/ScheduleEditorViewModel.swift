final class ScheduleEditorViewModel {
    
    // MARK: - Data Sources
    
    var days: [WeekDay] { trackerEditorViewModel.days }
    
    // MARK: - Tracker Editor View Model
    
    let trackerEditorViewModel: TrackerEditorViewModel
    
    // MARK: - Initializers
    
    init(from trackerEditorViewModel: TrackerEditorViewModel) {
        self.trackerEditorViewModel = trackerEditorViewModel
    }
    
    // MARK: - Internal Methods
    
    func updateSchedule(_ day: WeekDay, included: Bool) {
        trackerEditorViewModel.updateSchedule(day, included: included)
    }
}
