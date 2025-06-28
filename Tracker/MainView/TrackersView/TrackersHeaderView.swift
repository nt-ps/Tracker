import UIKit

final class TrackersHeaderView: UICollectionReusableView {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.tintColor = .YPColors.black
        // titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: TrackersHeaderView.self)
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            titleLabel.text = title ?? "Без заголовка"
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraints() { }
}
