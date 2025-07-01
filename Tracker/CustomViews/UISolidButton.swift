import UIKit

final class UISolidButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backgroundColor = .AppColors.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel?.textColor = .AppColors.white
        
        backgroundColor = .AppColors.black
        
        layer.masksToBounds = true
        layer.cornerRadius = 16 // TODO: Использовать базовую единицу.
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60) // TODO: Использовать базовую единицу.
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("UISolidButton.init(coder:) has not been implemented")
    }
}
