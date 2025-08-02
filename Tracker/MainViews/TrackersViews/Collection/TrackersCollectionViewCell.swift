import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.layer.masksToBounds = true
        infoView.layer.cornerRadius = infoViewCornerRadius
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        infoView.addSubview(emojiLabel)
        infoView.addSubview(nameLabel)
        
        return infoView
    } ()
    
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
    
    private lazy var controlView: UIView = {
        let controlView = UIView()
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        controlView.addSubview(counterLabel)
        controlView.addSubview(doneButton)
        
        return controlView
    } ()
    
    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        counterLabel.textColor = .AppColors.black
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        return counterLabel
    } ()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        let icon = UIImage(resource: enabledDoneButtonIconResource)
        doneButton.setImage(icon, for: .normal)
        doneButton.tintColor = .AppColors.white
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButtonCornerRadius
        doneButton.addTarget(
            self,
            action: #selector(didTapDoneButton),
            for: .touchUpInside
        )
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        return doneButton
    } ()
    
    // MARK: - UI Properties
    
    private lazy var infoViewCornerRadius = 16.0
    private lazy var infoViewPadding = 12.0
    
    private lazy var emojiLabelSize = 24.0
    private lazy var emojiLabelCornerRadius = emojiLabelSize / 2
    
    private lazy var controlViewXPadding = 12.0
    private lazy var controlViewTopPadding = 8.0
    private lazy var controlViewBottomPadding = 16.0
    
    private lazy var enabledDoneButtonIconResource: ImageResource = .Icons.plus
    private lazy var enabledDoneButtonIconSize = CGSize(width: 10.62, height: 10.21)
    private lazy var enabledDoneButtonOpacity: Float = 1.0
    
    private lazy var disabledDoneButtonIconResource: ImageResource = .Icons.done
    private lazy var disabledDoneButtonIconSize = CGSize(width: 12, height: 12)
    private lazy var disabledDoneButtonOpacity: Float = 0.3
    
    private lazy var doneButtonSize = 34.0
    private lazy var doneButtonCornerRadius = doneButtonSize / 2
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: TrackersCollectionViewCell.self)
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    var color: UIColor? {
        didSet (oldValue) {
            let newValue = color ?? .AppColors.black
            if oldValue != newValue {
                infoView.backgroundColor = newValue
                doneButton.backgroundColor = newValue
            }
        }
    }
    
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
    
    var daysNumber: Int? {
        didSet {
            let daysString = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: "Number of days marked"),
                daysNumber ?? 0
            )
            updateText(inLabel: counterLabel, to: daysString)
        }
    }
    
    var isDone: Bool? {
        didSet {
            let newValue = isDone ?? false
            updateDoneButton(isEnable: !newValue)
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(infoView)
        addSubview(controlView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Overridden Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapDoneButton() {
        delegate?.trackerCellDoneButtonDidTap(self)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.topAnchor.constraint(equalTo: topAnchor),
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoView.bottomAnchor.constraint(equalTo: controlView.topAnchor),
            
            emojiLabel.leadingAnchor.constraint(
                equalTo: infoView.leadingAnchor,
                constant: infoViewPadding
            ),
            emojiLabel.topAnchor.constraint(
                equalTo: infoView.topAnchor,
                constant: infoViewPadding
            ),
            emojiLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: infoView.trailingAnchor
            ),
            emojiLabel.topAnchor.constraint(lessThanOrEqualTo: infoView.topAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiLabelSize),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(
                equalTo: infoView.leadingAnchor,
                constant: infoViewPadding
            ),
            nameLabel.topAnchor.constraint(
                greaterThanOrEqualTo: emojiLabel.bottomAnchor
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: infoView.trailingAnchor,
                constant: -infoViewPadding
            ),
            nameLabel.bottomAnchor.constraint(
                equalTo: infoView.bottomAnchor,
                constant: -infoViewPadding
            ),
        
            controlView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            counterLabel.centerYAnchor.constraint(
                equalTo: doneButton.centerYAnchor
            ),
            counterLabel.leadingAnchor.constraint(
                equalTo: controlView.leadingAnchor,
                constant: controlViewXPadding
            ),
            counterLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: doneButton.leadingAnchor
            ),
            
            doneButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: counterLabel.trailingAnchor
            ),
            doneButton.topAnchor.constraint(
                equalTo: controlView.topAnchor,
                constant: controlViewTopPadding
            ),
            doneButton.trailingAnchor.constraint(
                equalTo: controlView.trailingAnchor,
                constant: -controlViewXPadding
            ),
            doneButton.bottomAnchor.constraint(
                equalTo: controlView.bottomAnchor,
                constant: -controlViewBottomPadding
            ),
            doneButton.widthAnchor.constraint(equalToConstant: doneButtonSize),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor)
        ])
        
        if let doneButtonIcon = doneButton.imageView {
            NSLayoutConstraint.activate([
                doneButtonIcon.widthAnchor.constraint(
                    equalToConstant: enabledDoneButtonIconSize.width
                ),
                doneButtonIcon.heightAnchor.constraint(
                    equalToConstant: enabledDoneButtonIconSize.height
                ),
                doneButtonIcon.centerXAnchor.constraint(
                    equalTo: doneButton.centerXAnchor
                ),
                doneButtonIcon.centerYAnchor.constraint(
                    equalTo: doneButton.centerYAnchor
                )
            ])
        }
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
    
    private func updateDoneButton(isEnable: Bool) {
        if isEnable {
            updateDoneButton(
                iconResource: enabledDoneButtonIconResource,
                iconSize: enabledDoneButtonIconSize,
                opacity: enabledDoneButtonOpacity
            )
        } else {
            updateDoneButton(
                iconResource: disabledDoneButtonIconResource,
                iconSize: disabledDoneButtonIconSize,
                opacity: disabledDoneButtonOpacity
            )
        }
    }
    
    private func updateDoneButton(
        iconResource: ImageResource,
        iconSize: CGSize,
        opacity: Float
    ) {
        let icon = UIImage(resource: iconResource)
        doneButton.setImage(icon, for: .normal)
        doneButton.layer.opacity = opacity
        
        guard let doneButtonIcon = doneButton.imageView else { return }
        
        NSLayoutConstraint.activate([
            doneButtonIcon.widthAnchor.constraint(equalToConstant: iconSize.width),
            doneButtonIcon.heightAnchor.constraint(equalToConstant: iconSize.height)
        ])
    }
}
