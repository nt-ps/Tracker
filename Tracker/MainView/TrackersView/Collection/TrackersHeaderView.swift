import UIKit

final class TrackersHeaderView: UICollectionReusableView {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = TrackersHeaderView.getTitleLabel()

    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: TrackersHeaderView.self)
    
    // Сделал так, потому что предложенный в теории
    // метод вычисления высоты валит приложение.
    // Вынес в статик, чтобы обращаться без привязки к объекту.
    // Необходимые для вычисления поля тоже пометил как статические,
    // иначе ругается.
    static var defaultHeight: CGFloat = {
        let label = TrackersHeaderView.getTitleLabel()
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
            titleLabel.text = title ?? TrackersHeaderView.defaultTitle
        }
    }
    
    // MARK: - Private Properties
    
    private static var defaultTitle = "Без названия"
    
    // TODO: Вычислять относительно базовой единицы.
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
        // TODO: Вывести значения в поля класса.
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: TrackersHeaderView.viewXPadding
            ),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: TrackersHeaderView.viewYPadding
            ),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -TrackersHeaderView.viewXPadding
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -TrackersHeaderView.viewYPadding
            ),
        ])
    }
    
    // MARK: - Private Methods
    
    private static func getTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = TrackersHeaderView.defaultTitle
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .AppColors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }
}
