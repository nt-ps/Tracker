struct Schedule {
    private(set) var days: [WeekDay]
    
    init(days: [WeekDay] = []) {
        self.days = days
    }
    
    func contains(weekDay: WeekDay) -> Bool
    {
        contains(dayNumber: weekDay.rawValue)
    }
    
    func contains(dayNumber: Int) -> Bool {
        days.contains { day in
            day.rawValue == dayNumber
        }
    }
    
    func toString() -> String {
        if WeekDay.allCases.allSatisfy({ days.contains($0) }) {
            return "Каждый день"
        }
        
        let array = days.map{ $0.shortName }
        let result = array.joined(separator: ", ")
        return result
    }
}
