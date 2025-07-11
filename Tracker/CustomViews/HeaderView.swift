import UIKit

final class HeaderView: UICollectionReusableView {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = HeaderView.getTitleLabel()

    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: HeaderView.self)
    
    static var defaultHeight: CGFloat = {
        let label = HeaderView.getTitleLabel()
        let labelSize = label.sizeThatFits(
            CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        return labelSize.height + viewYPadding * 2
    } ()
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            titleLabel.text = title ?? HeaderView.defaultTitle
        }
    }
    
    // MARK: - Private Properties
    
    private static var defaultTitle = "Без названия"

    private static var viewXPadding = 28.0
    private static var viewYPadding = 12.0
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: HeaderView.viewXPadding
            ),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: HeaderView.viewYPadding
            ),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -HeaderView.viewXPadding
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -HeaderView.viewYPadding
            ),
        ])
    }
    
    // MARK: - Private Methods
    
    private static func getTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = HeaderView.defaultTitle
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .AppColors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }
}
