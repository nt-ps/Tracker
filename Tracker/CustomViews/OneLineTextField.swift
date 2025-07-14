import UIKit

final class OneLineTextField: UIView {
    
    // MARK: - UI Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, limitLabel])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var textField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        textField.backgroundColor = .AppColors.background
        textField.clearButtonMode = .whileEditing
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.attributedPlaceholder = NSAttributedString(
            string: "Placeholder Text",
            attributes: [
                .foregroundColor: UIColor.AppColors.gray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.addTarget(
            self,
            action: #selector(editingChanged(sender:)),
            for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    } ()
    
    private lazy var limitLabel: UILabel = {
        let limitLabel = UILabel()
        limitLabel.textAlignment = .center
        limitLabel.text = "Ограничение \(maxLength) символов"
        limitLabel.font = .systemFont(ofSize: 17, weight: .regular)
        limitLabel.textColor = .AppColors.red
        limitLabel.translatesAutoresizingMaskIntoConstraints = false
        limitLabel.isHidden = true
        return limitLabel
    } ()
    
    // MARK: - Internal Properties
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder ?? ""
        }
    }
    
    var text: String? { textField.text }
    
    var editingAction: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let maxLength = 38
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("OneLineTextField.init(coder:) has not been implemented")
    }

    // MARK: - Text Field Actions
    
    @objc
    private func editingChanged(sender: UITextField) {
        if
            let text = sender.text,
            text.count > maxLength
        {
            sender.text = String(text.dropLast(text.count - maxLength))
            limitLabel.isHidden = false
            return
        } else {
            editingAction?()
            limitLabel.isHidden = true
        }
    }

    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
