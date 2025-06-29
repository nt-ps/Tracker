// TODO: Подумать над тем, чтобы поменять на enum.
struct Schedule {
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    let sunday: Bool
    
    func contains(weekday: Int) -> Bool {
        switch weekday{
        case 1:
            return sunday
        case 2:
            return monday
        case 3:
            return tuesday
        case 4:
            return wednesday
        case 5:
            return thursday
        case 6:
            return friday
        case 7:
            return saturday
        default:
            return false
        }
    }
}
