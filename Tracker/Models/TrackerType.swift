import Foundation

enum TrackerType {
    case habit(Schedule)
    case event
    
    init(from string: String) {
        if string.contains("habit") {
            var weekDays: [WeekDay] = []
            for i in 1...7 {
                if
                    string.contains("\(i)"),
                    let weekDay = WeekDay(rawValue: i)
                {
                    weekDays.append(weekDay)
                }
            }
            let schedule = Schedule(days: weekDays)
            self = .habit(schedule)
        } else {
            self = .event
        }
    }
    
    func toString() -> String {
        var result = "[\(self)]["
        switch self {
        case .habit(let schedule):
            schedule.days.forEach { result.append("\($0.rawValue) ") }
        default:
            Array(1...7).forEach { result.append("\($0) ") }
        }
        result += "]"
        return result
    }
}
