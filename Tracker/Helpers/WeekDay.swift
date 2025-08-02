import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var name: String {
        switch self {
        case .monday: NSLocalizedString("mondayFull", comment: "Full name of monday")
        case .tuesday: NSLocalizedString("tuesdayFull", comment: "Full name of tuesday")
        case .wednesday: NSLocalizedString("wednesdayFull", comment: "Full name of wednesday")
        case .thursday: NSLocalizedString("thursdayFull", comment: "Full name of thursday")
        case .friday: NSLocalizedString("fridayFull", comment: "Full name of friday")
        case .saturday: NSLocalizedString("saturdayFull", comment: "Full name of saturday")
        case .sunday: NSLocalizedString("sundayFull", comment: "Full name of sunday")
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: NSLocalizedString("mondayShort", comment: "Short name of monday")
        case .tuesday: NSLocalizedString("tuesdayShort", comment: "Short name of tuesday")
        case .wednesday: NSLocalizedString("wednesdayShort", comment: "Short name of wednesday")
        case .thursday: NSLocalizedString("thursdayShort", comment: "Short name of thursday")
        case .friday: NSLocalizedString("fridayShort", comment: "Short name of friday")
        case .saturday: NSLocalizedString("saturdayShort", comment: "Short name of saturday")
        case .sunday: NSLocalizedString("sundayShort", comment: "Short name of sunday")
        }
    }
}
