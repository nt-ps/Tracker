import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var characterLabel: UILabel = {
        let characterLabel = UILabel()
        characterLabel.font = .systemFont(ofSize: 32, weight: .bold)
        characterLabel.textAlignment = .center
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        return characterLabel
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: CharacterCollectionViewCell.self)
    
    // MARK: - Internal Properties
    
    var character: Character? {
        didSet {
            if
                let characterString = character != nil ? String(character!) : nil
            {
                if characterString != characterLabel.text {
                    characterLabel.text = characterString
                }
            } else {
                characterLabel.text = ""
            }
        }
    }
    
    // MARK: - Overridden Properties
    
    override var isSelected: BooleanLiteralType {
        didSet(oldValue) {
            if isSelected != oldValue {
                if isSelected {
                    contentView.backgroundColor = .AppColors.lightGray
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
        
        addSubview(characterLabel)
        
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
            characterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
