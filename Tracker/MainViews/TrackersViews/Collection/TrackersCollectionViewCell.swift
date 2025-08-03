import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
     lazy var infoView: TrackerInfoView = {
        let infoView = TrackerInfoView()
        infoView.layer.masksToBounds = true
        infoView.layer.cornerRadius = infoViewCornerRadius
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
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
            infoView.emoji = emoji
        }
    }
    
    var name: String? {
        didSet {
            infoView.name = name
        }
    }
    
    var daysNumber: Int? {
        didSet {
            counterLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: "Number of days marked"),
                daysNumber ?? 0
            )
        }
    }
    
    var isDone: Bool? {
        didSet {
            let newValue = isDone ?? false
            updateDoneButton(isEnable: !newValue)
        }
    }
    
    var contextMenuPreview: UIViewController? {
        let vc = UIViewController()
        
        let size = self.infoView.bounds.size
        vc.preferredContentSize = CGSize(width: size.width, height: size.height)
        
        let infoViewClone = infoView.clone
        vc.view.addSubview(infoViewClone)
        NSLayoutConstraint.activate([
            infoViewClone.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            infoViewClone.topAnchor.constraint(equalTo: vc.view.topAnchor),
            infoViewClone.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            infoViewClone.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])

        return vc
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
