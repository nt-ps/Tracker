import UIKit

final class OneLineTextField: UIView {
    
    // MARK: - UI Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, messageLabel])
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
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17, weight: .regular)
        messageLabel.textColor = .AppColors.red
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isHidden = true
        return messageLabel
    } ()
    
    // MARK: - Internal Properties
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder ?? ""
        }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var message: String? {
        didSet {
            guard let message, !message.isEmpty else {
                messageLabel.isHidden = true
                return
            }
            
            messageLabel.isHidden = false
            messageLabel.text = message
        }
    }
    
    var editingAction: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("OneLineTextField.init(coder:) has not been implemented")
    }

    // MARK: - Text Field Actions
    
    @objc
    private func editingChanged(sender: UITextField) {
        editingAction?()
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
