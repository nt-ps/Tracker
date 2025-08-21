import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: Character
    let type: TrackerType
    
    init(
        id: UUID = UUID(),
        name: String = NSLocalizedString("defaultTitle", comment: "Default title"),
        color: UIColor = .TrackerColors.color5,
        emoji: Character = "🥸",
        type: TrackerType = .event
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.type = type
    }
}
