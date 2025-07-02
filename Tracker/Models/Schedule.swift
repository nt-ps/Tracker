// TODO: Подумать над тем, чтобы поменять на enum.
struct Schedule {
    let days: [WeekDay]
    
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
}
