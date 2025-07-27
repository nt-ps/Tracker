import UIKit

final class SwitchTableViewCell: UITableViewCell, ParametersTableViewCellProtocol {
    
    // MARK: - UI Views
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .AppColors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    } ()
    
    // Не нашел способа впихнуть switchView в accessoryView так,
    // чтобы можно было настроить констрейнты.
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        switchView.onTintColor = .AppColors.blue
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(
            self,
            action: #selector(switcherChanged(sender:)),
            for: .valueChanged)
        return switchView
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: SwitchTableViewCell.self)
    
    // MARK: - Internal Properties
    
    // TODO: Продумать архитектуру ячеек таблицы параметров, и их взаимодействие с другими элементами.
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
     
    var isOn: Bool {
        get { switchView.isOn }
        set { switchView.isOn = newValue }
    }
    
    var value: Any? // TODO: При инициализации ячейки задавать ей значение, за которое она отвечает.
    
    var tapAction: ((Any?, Bool) -> Void)?
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("SwitchTableViewCell.init(coder:) has not been implemented")
    }
    
    // MARK: - Switcher Actions
    
    @objc private func switcherChanged(sender: UISwitch) {
        tapAction?(value, sender.isOn)
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
                lessThanOrEqualTo: switchView.leadingAnchor
            ),
            
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchView.leadingAnchor.constraint(
                greaterThanOrEqualTo: titleLabel.trailingAnchor
            ),
            switchView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            )
        ])
    }
}
