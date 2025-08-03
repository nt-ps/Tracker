import UIKit

final class TrackerInfoView: UIView {
    // MARK: - Views
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        // Установил 13 вместо 16, потому что при значении 16
        // эмодзи слишком большое в сравнении с макетом.
        emojiLabel.font = .systemFont(ofSize: 13, weight: .regular)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .AppColors.white.withAlphaComponent(0.3)
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = emojiLabelCornerRadius
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    } ()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = false
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .AppColors.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    } ()
    
    // MARK: - UI Properties

    private lazy var infoViewPadding = 12.0
    
    private lazy var emojiLabelSize = 24.0
    private lazy var emojiLabelCornerRadius = emojiLabelSize / 2
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    var emoji: Character? {
        didSet {
            let emojiString = emoji != nil ? String(emoji!) : nil
            updateText(inLabel: emojiLabel, to: emojiString)
        }
    }
    
    var name: String? {
        didSet {
            updateText(inLabel: nameLabel, to: name)
        }
    }
    
    var clone: TrackerInfoView {
        let clone = TrackerInfoView(frame: self.frame)
        clone.backgroundColor = self.backgroundColor
        clone.emoji = self.emoji
        clone.name = self.name
        return clone
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emojiLabel)
        addSubview(nameLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: infoViewPadding
            ),
            emojiLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: infoViewPadding
            ),
            emojiLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor
            ),
            emojiLabel.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiLabelSize),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: infoViewPadding
            ),
            nameLabel.topAnchor.constraint(
                greaterThanOrEqualTo: emojiLabel.bottomAnchor
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -infoViewPadding
            ),
            nameLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -infoViewPadding
            )
        ])
    }
    
    private func updateText(inLabel label: UILabel, to newValue: String?) {
        if let newValue {
            if newValue != label.text {
                label.text = newValue
            }
        } else {
            label.text = ""
        }
    }
}
