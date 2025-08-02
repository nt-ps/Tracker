import Foundation

enum TrackerBuilderError: Error {
    case emptyName
    case longName(Int)
    case trackerIsNotFull
    
    var localizedDescription: String? {
        switch self {
        case .emptyName:
            return nil
        case .longName(let maxValue):
            return String.localizedStringWithFormat(
                NSLocalizedString("stringLengthLimit", comment: "Number of characters entered"),
                maxValue
            )
        case .trackerIsNotFull:
            return "Трекер определен не полностью"
        }
    }
}
