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
                    monday: true,
                    tuesday: true,
                    wednesday: true,
                    thursday: true,
                    friday: true,
                    saturday: false,
                    sunday: false
                )
            )
        )
        
        return [TrackerCategory(title: "Разное", trackers: [tracker])]
    } ()
}
