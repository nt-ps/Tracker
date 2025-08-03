import UIKit

final class ButtonCellView: UITableViewCell, ParametersTableViewCellProtocol {
    
    // MARK: - UI Views
    
    // Есть дефолтный тип ячейки с подтекстом, но я не нашел
    // рабочего способа изменить стиль текста и отступы.
    // Поэтому добавил лейблы самостоятельно.
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .AppColors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    } ()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = .AppColors.gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: ButtonCellView.self)
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
     
    var subtitle: String? {
        didSet {
            if
                let subtitle,
                !subtitle.isEmpty
            {
                subtitleLabel.isHidden = false
                subtitleLabel.text = subtitle
            } else {
                subtitleLabel.isHidden = true
            }
        }
    }
    
    var tapAction: (() -> Void)?
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .AppColors.background
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("ButtonCellView.init(coder:) has not been implemented")
    }

    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            )
        ])
    }
}
