import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding: UIEdgeInsets?

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        if let textPadding {
            return rect.inset(by: textPadding)
        } else {
            return rect
        }
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        if let textPadding {
            return rect.inset(by: textPadding)
        } else {
            return rect
        }
    }
}
