import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: TrackersCollectionViewCell.self)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
