import Foundation

enum TrackerBuilderError: Error {
    case emptyName
    case longName(Int)
    case trackerIsNotFull
    
    var localizedDescription: String? {
        switch self {
        case .emptyName: nil
        case .longName(let maxValue): getLongNameErrorString(maxValue: maxValue)
        case .trackerIsNotFull: "Трекер определен не полностью"
        }
    }
    
    private func getLongNameErrorString(maxValue: Int) -> String {
        var string = "Ограничение \(maxValue) "

        switch maxValue % 10 {
        case 1:
            string += "символ"
            break
        case 2, 3, 4:
            string += "символа"
            break
        default:
            string += "символов"
            break
        }
        
        return string
    }
}
