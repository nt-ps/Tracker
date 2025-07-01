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
}
