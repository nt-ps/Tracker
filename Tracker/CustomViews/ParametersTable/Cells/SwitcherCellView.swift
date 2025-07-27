import UIKit

final class SwitcherCellView: UITableViewCell, ParametersTableViewCellProtocol {
    
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
        switchView.onTintColor = .AppColors.blue
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(
            self,
            action: #selector(switcherChanged(sender:)),
            for: .valueChanged)
        return switchView
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: SwitcherCellView.self)
    
    // MARK: - View Model
    
    private var viewModel: SwitcherCellViewModel?
    
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
        print("SwitcherCellView.init(coder:) has not been implemented")
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: SwitcherCellViewModel) {
        self.viewModel = viewModel
        updateView()
    }
    
    // MARK: - Switcher Actions
    
    @objc private func switcherChanged(sender: UISwitch) {
        viewModel?.updateModel(sender.isOn)
    }

    // MARK: - UI Updates
    
    private func updateView() {
        guard let viewModel else { return }
        
        titleLabel.text = viewModel.title
        switchView.isOn = viewModel.isOn
    }
    
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
