import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: Character
    // let schedule: Schedule // Да, не по ТЗ, но на мой вгляд вкладывать расписание
                              // как ассоциированное значение к типу удобнее.
                              // Тогда оно не будет доступно для нерегулярных соббытий.
    let type: TrackerType
    
    init(
        name: String,
        color: UIColor = .TrackerColors.color5,
        emoji: Character = "🥸",
        type: TrackerType = .event
    ) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.type = type
    }
}
