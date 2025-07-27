import Foundation

enum CategoryEditorError: Error {
    case emptyTitle
    case longTitle(Int)
    
    var localizedDescription: String? {
        switch self {
        case .emptyTitle: nil
        case .longTitle(let maxValue): getLongTitleErrorString(maxValue: maxValue)
        }
    }
    
    private func getLongTitleErrorString(maxValue: Int) -> String {
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
