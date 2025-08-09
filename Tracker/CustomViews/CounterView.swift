import UIKit

final class CounterView: UIView {
    
    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            numberLabel, titleLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    } ()
    
    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = .systemFont(ofSize: 34, weight: .bold)
        numberLabel.textColor = .AppColors.black
        numberLabel.textAlignment = .left
        return numberLabel
    } ()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .AppColors.black
        titleLabel.textAlignment = .left
        return titleLabel
    } ()
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [
            UIColor.TrackerColors.color1.cgColor,
            UIColor.TrackerColors.color9.cgColor,
            UIColor.TrackerColors.color3.cgColor
        ]
        return gradient
    } ()
    
    // MARK: - UI Properties
    
    private let borderWidth = 1.0
    private let borderRadius = 16.0
    
    private let xPadding = 12.0
    
    // MARK: - Internal Properties
    
    var number: Int? {
        didSet {
            if let number {
                numberLabel.text = "\(number)"
            }
        }
    }
    
    var title: String? {
        didSet {
            if let title {
                titleLabel.text = title
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xPadding)
        ])
        
        layer.addSublayer(gradient)
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        
        gradient.frame = CGRect(origin: .zero, size: layer.frame.size)
    
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.path = UIBezierPath(
            roundedRect: CGRect(
                origin: CGPoint(x: borderWidth / 2.0, y: borderWidth / 2.0),
                size: CGSize(
                    width: layer.frame.width - borderWidth,
                    height: layer.frame.height - borderWidth
                )
            ),
            byRoundingCorners: [
                .topRight,
                .topLeft,
                .bottomLeft,
                .bottomRight
            ],
            cornerRadii: CGSize(
                width: borderRadius,
                height: borderRadius
            )
        ).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
