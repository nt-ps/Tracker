final class ScheduleEditorViewModel {
    
    // MARK: - Bindings
    
    var onScheduleStateChange: Binding<String?>?
    
    // MARK: - Internal Properties
    
    var days: [SwitcherCellViewModel] {
        if case .habit = model.type {
            let days: [SwitcherCellViewModel] = WeekDay.allCases.map {
                return SwitcherCellViewModel(
                    title: $0.name,
                    value: $0,
                    isOn: selectedDays.contains($0),
                    changeAction: { [weak self] value, isOn in
                        guard let day = value as? WeekDay else { return }
                        self?.updateSchedule(day, isOn: isOn)
                    }
                )
            }
            return days
        } else {
            return []
        }
    }
    
    // MARK: - Private Properties
    
    private var selectedDays: [WeekDay] = []
    
    // MARK: - Model
    
    private let model: TrackerBuilder
    
    // MARK: - Initializers
    
    init(for model: TrackerBuilder) {
        self.model = model
        
        if case .habit(let schedule) = model.type {
            self.selectedDays = schedule.days
        }
    }
    
    // MARK: - Internal Methods
    
    func updateSchedule(_ day: WeekDay, isOn: Bool) {
        if selectedDays.contains(day), !isOn {
            selectedDays.removeAll { $0.rawValue == day.rawValue }
        } else if !selectedDays.contains(day), isOn {
            selectedDays.append(day)
        }
    }

    func saveSchedule() {
        if case .habit = model.type {            
            let schedule = Schedule(days: selectedDays)
            model.type = .habit(schedule)
            
            onScheduleStateChange?(schedule.toString())
        }
    }
}
