import Foundation

final class TrackersMockData {
    static let share = TrackersMockData()
    static let defaultCategoryTitle = "Разное"
    
    var data: [TrackerCategory] { dataValue }
    
    var count: Int { dataValue.reduce(0) { $0 + $1.trackers.count } }
    
    private var dataValue: [TrackerCategory] = []
    
    private init() {
        let tracker = Tracker(
            name: "Поливать растения",
            color: .TrackerColors.color5,
            emoji: "🥸",
            type: .habit(
                Schedule(
                    days: [
                        .monday,
                        .tuesday,
                        .wednesday,
                        .thursday,
                        .friday
                    ]
                )
            )
        )
        
        let category = TrackerCategory(title: TrackersMockData.defaultCategoryTitle, trackers: [tracker])
        dataValue.append(category)
    }
    
    func addTracker(_ tracker: Tracker) {
        var trackers = dataValue[0].trackers
        trackers.append(tracker)
        let title = dataValue[0].title
        dataValue[0] = TrackerCategory(title: title, trackers: trackers)
    }
}
