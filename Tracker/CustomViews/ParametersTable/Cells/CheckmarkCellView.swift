import UIKit

final class CheckmarkCellView: UITableViewCell, ParametersTableViewCellProtocol {
    
    // MARK: - UI Views
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        // titleLabel.text = "fvevfvee лотло дтдлтд лдтд vve erewrwerwerewer wr we wr ew rweere" // TODO: Удалить!!!
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .AppColors.black
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: CheckmarkCellView.self)
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isChecked: Bool? {
        didSet {
            if let isChecked {
                accessoryType = isChecked ? .checkmark : .none
            }
        }
    }
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        accessoryType = .none
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("CheckmarkCellView.init(coder:) has not been implemented")
    }

    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -48
            )
        ])
    }
}
