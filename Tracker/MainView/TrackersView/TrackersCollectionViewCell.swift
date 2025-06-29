import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .TrackerColors.green
        infoView.layer.masksToBounds = true
        infoView.layer.cornerRadius = infoViewCornerRadius
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        infoView.addSubview(emojiLabel)
        infoView.addSubview(nameLabel)
        
        return infoView
    } ()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "😪"
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
        nameLabel.text = "Поливать растения"
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
        counterLabel.text = "0 дней"
        counterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        counterLabel.textColor = .AppColors.black
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        return counterLabel
    } ()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.setImage(UIImage(named: doneButtonIconName), for: .normal)
        doneButton.tintColor = .AppColors.white
        doneButton.backgroundColor = .TrackerColors.green
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButtonCornerRadius
        doneButton.addTarget(
            self,
            action: #selector(self.didTapDoneButton),
            for: .touchUpInside
        )
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        return doneButton
    } ()
    
    // MARK: - UI Properties
    
    private lazy var baseUnit = 8.0
    
    private lazy var infoViewCornerRadius = baseUnit * 2
    private lazy var infoViewPadding = baseUnit * 3 / 2
    
    private lazy var emojiLabelSize = baseUnit * 3
    private lazy var emojiLabelCornerRadius = emojiLabelSize / 2
    
    private lazy var controlViewXPadding = baseUnit * 3 / 2
    private lazy var controlViewTopPadding = baseUnit
    private lazy var controlViewBottomPadding = baseUnit * 2
    
    private lazy var doneButtonIconName = "Icons/Plus"
    private lazy var doneButtonIconSize = CGSize(width: 10.62, height: 10.21)
    private lazy var doneButtonSize = 34.0
    private lazy var doneButtonCornerRadius = doneButtonSize / 2
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: TrackersCollectionViewCell.self)
    
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
    
    // MARK: - Overrided methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapDoneButton() { }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.topAnchor.constraint(equalTo: topAnchor),
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoView.bottomAnchor.constraint(equalTo: controlView.topAnchor),
            
            emojiLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: infoViewPadding),
            emojiLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: infoViewPadding),
            emojiLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor),
            emojiLabel.topAnchor.constraint(lessThanOrEqualTo: infoView.topAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiLabelSize),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: infoViewPadding),
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -infoViewPadding),
            nameLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -infoViewPadding),
        
            controlView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            counterLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(
                equalTo: controlView.leadingAnchor,
                constant: controlViewXPadding
            ),
            counterLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneButton.leadingAnchor),
            
            doneButton.leadingAnchor.constraint(greaterThanOrEqualTo: counterLabel.trailingAnchor),
            doneButton.topAnchor.constraint(equalTo: controlView.topAnchor, constant: controlViewTopPadding),
            doneButton.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -controlViewXPadding),
            doneButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -controlViewBottomPadding),
            doneButton.widthAnchor.constraint(equalToConstant: doneButtonSize),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor),
        ])
        
        if let doneButtonIcon = doneButton.imageView {
            NSLayoutConstraint.activate([
                doneButtonIcon.widthAnchor.constraint(equalToConstant: doneButtonIconSize.width),
                doneButtonIcon.heightAnchor.constraint(equalToConstant: doneButtonIconSize.height),
                doneButtonIcon.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor),
                doneButtonIcon.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            ])
        }
    }
}

/*
 #Preview("Cell", traits: .sizeThatFitsLayout) {
 TrackersCollectionViewCell()
 }
 */
