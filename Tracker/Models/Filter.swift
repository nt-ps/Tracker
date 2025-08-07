import Foundation

// В задании написано, что вильтр нужно сохранять в CoreData или UserDefaults,
// но при этом указано: "Для случая перезапуска приложения можно не сохранять выбранный фильтр".
// Смысла в сохранении фильтра не вижу, поэтому не реализовывал.
struct Filter {
    var date: Date
    private(set) var isFinished: Bool?
    var name: String?
    
    private static var defaultDate: Date { Date.now }
    private static var defaultIsFinishedFlag: Bool? { nil }
    
    init(date: Date = defaultDate, isFinished: Bool? = nil) {
        self.date = date
        self.isFinished = isFinished
    }
    
    mutating func reset() {
        date = Filter.defaultDate
        isFinished = Filter.defaultIsFinishedFlag
    }
    
    mutating func allFor(_ date: Date) {
        self.date = date
        isFinished = Filter.defaultIsFinishedFlag
    }
    
    mutating func finishedFor(_ date: Date) {
        self.date = date
        self.isFinished = true
    }
    
    mutating func unfinishedFor(_ date: Date) {
        self.date = date
        self.isFinished = false
    }
}
