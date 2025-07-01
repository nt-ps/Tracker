import UIKit

final class OutlineButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backgroundColor = .AppColors.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.AppColors.red, for: .normal)
        
        backgroundColor = .clear
        
        layer.masksToBounds = true
        layer.cornerRadius = 16 // TODO: Использовать базовую единицу.
        layer.borderWidth = 1
        layer.borderColor = UIColor.AppColors.red.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60) // TODO: Использовать базовую единицу.
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("UISolidButton.init(coder:) has not been implemented")
    }
}
