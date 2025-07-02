import Foundation

final class TrackersDataMock {
    static var data: [TrackerCategory] = {
        let tracker = Tracker(
            id: UUID(),
            name: "Поливать растения",
            color: .TrackerColors.green,
            emoji: "🥸",
            type: .habit(
                Schedule(
                    days: [
                        .monday,
                        .tuesday,
                        .thursday,
                        .tuesday,
                        .friday
                    ]
                )
            )
        )
        
        return [TrackerCategory(title: "Разное", trackers: [tracker])]
    } ()
}
