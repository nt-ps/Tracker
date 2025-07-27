import UIKit

final class TrackerEditorModel {
    
    // MARK: - Tracker Data
    
    private(set) var id: UUID
    private(set) var name: String?
    private(set) var category: String?
    private(set) var color: UIColor?
    private(set) var emoji: Character?
    private(set) var type: TrackerType?
    // TODO: Продумать момент с установкой расписания.
    var schedule: Schedule? {
        switch type {
        case .habit(let schedule): schedule
        default: nil
        }
    }
    
    // MARK: - Private Properties
    
    private let requiredNameLength = 38
    
    // MARK: - Initializers
    
    init() {
        self.id = UUID()
    }
    
    // MARK: - Internal Methods
    
    func setType(_ type: TrackerType) {
        self.type = type
    }
    
    func didNameEnter(_ name: String?) -> Result<Void, Error> {
        do {
            try validate(name: name)
        } catch {
            self.name = nil
            return .failure(error)
        }

        self.name = name
        
        return .success(())
    }
    
    func setCategory(_ category: String?) {
        self.category = category
    }
    
    func setEmoji(_ emoji: Character?) {
        self.emoji = emoji
    }
    
    func setColor(_ color: UIColor?) {
        self.color = color
    }
    
    func updateSchedule(_ day: WeekDay, included: Bool) {
        switch type {
        case .habit(let schedule):
            var days = schedule.days
            
            let index = days.firstIndex(of: day)
            if let index, !included {
                days.remove(at: index)
            } else if index == nil, included {
                days.append(day)
            }
            
            type = .habit(Schedule(days: days))
        default: return
        }
    }
    
    func validate() -> Bool {
        guard
            let type,
            let name,
            !name.isEmpty,
            let category,
            let color,
            let emoji
        else {
            return false
        }
        
        switch type {
        case .habit(let schedule): return !schedule.isEmpty
        case .event: return true
        }
    }
    
    func getTracker() throws -> Tracker {
        // TODO: Не нравится, что guard идет по перменным тут, и в validate.
        guard
            validate(),
            let name,
            let color,
            let emoji,
            let type
        else { throw TrackerEditorError.trackerIsNotFull }
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            type: type
        )
    }
    
    // MARK: - Private Methods
    
    private func validate(name string: String?) throws {
        guard
            let string,
            !string.isEmpty
        else {
            throw TrackerEditorError.emptyName
        }
        
        if string.count > requiredNameLength {
            throw TrackerEditorError.longName(requiredNameLength)
        }
    }
}
