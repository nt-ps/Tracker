import Foundation

enum CategoryEditorError: Error {
    case emptyTitle
    case longTitle(Int)
    
    var localizedDescription: String? {
        switch self {
        case .emptyTitle:
            return nil
        case .longTitle(let maxValue):
            return String.localizedStringWithFormat(
                NSLocalizedString("stringLengthLimit", comment: "Number of characters entered"),
                maxValue
            )
        }
    }
}
