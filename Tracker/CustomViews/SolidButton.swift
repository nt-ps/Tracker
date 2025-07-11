import UIKit

final class SolidButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backgroundColor = isEnabled ? .AppColors.black : .AppColors.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.AppColors.white, for: .normal)
        
        backgroundColor = .AppColors.black
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("SolidButton.init(coder:) has not been implemented")
    }
}
