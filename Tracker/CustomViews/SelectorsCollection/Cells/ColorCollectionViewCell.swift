import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = .orange
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 13 // Выбрал чуть больший радиус, чтобы
                                          // скругления на разных уровнях были пропорциональны
                                          // друг другу. В макете пропорции не соблюдены и мне
                                          // это не понравилось.
        colorView.layer.borderWidth = 3
        colorView.layer.borderColor = UIColor.AppColors.white.cgColor
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    } ()
    
    // MARK: - UI Properties
    
    private lazy var cellPadding = 3.0
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: ColorCollectionViewCell.self)
    
    // MARK: - Internal Properties
    
    var color: UIColor? {
        didSet (oldValue) {
            let newValue = color ?? .AppColors.white
            if oldValue != newValue {
                colorView.backgroundColor = newValue
            }
        }
    }
    
    // MARK: - Overridden Properties
    
    override var isSelected: BooleanLiteralType {
        didSet(oldValue) {
            if isSelected != oldValue {
                if isSelected {
                    contentView.backgroundColor = color?.withAlphaComponent(0.3)
                } else {
                    contentView.backgroundColor = .clear
                }
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        addSubview(colorView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Overridden Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: cellPadding
            ),
            colorView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: cellPadding
            ),
            colorView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -cellPadding
            ),
            colorView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -cellPadding
            )
        ])
    }
}
