import UIKit

final class SolidButton: UIButton {
    var enabledBackgroundColor: UIColor? {
        didSet {
            updateBackground()
        }
    }
    
    var disabledBackgroundColor: UIColor? {
        didSet {
            updateBackground()
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            updateBackground()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(titleColor, for: .normal)
        
        defer {
            enabledBackgroundColor = .AppColors.black
            disabledBackgroundColor = .AppColors.gray
            titleColor = .AppColors.white
        }

        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("SolidButton.init(coder:) has not been implemented")
    }
    
    private func updateBackground() {
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }
}
