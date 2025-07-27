import UIKit

final class TrackerBuilder {
    
    // MARK: - Tracker Data

    private(set) var name: String?
    var category: String?
    var color: UIColor?
    var emoji: Character?
    var type: TrackerType?
    private var id: UUID
    
    // MARK: - Private Properties
    
    private let requiredNameLength = 38
    
    // MARK: - Initializers
    
    init() {
        self.id = UUID()
    }
    
    // MARK: - Internal Methods
    
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
    
    func validate() -> Bool {
        guard
            let type,
            let name,
            !name.isEmpty,
            category != nil,
            color != nil,
            emoji != nil
        else {
            return false
        }
        
        if
            case .habit(let schedule) = type,
            schedule.isEmpty
        {
            return false
        } else {
            return true
        }
    }
    
    func getTracker() throws -> Tracker {
        guard validate() else { throw TrackerBuilderError.trackerIsNotFull }
        // Допускаю анврап, потому что в validate проходит проверка на nil.
        return Tracker(id: id, name: name!, color: color!, emoji: emoji!, type: type!)
    }
    
    // MARK: - Private Methods
    
    private func validate(name string: String?) throws {
        guard let string, !string.isEmpty else {
            throw TrackerBuilderError.emptyName
        }
        
        if string.count > requiredNameLength {
            throw TrackerBuilderError.longName(requiredNameLength)
        }
    }
}
