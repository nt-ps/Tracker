import UIKit

final class CheckmarkCellView: UITableViewCell, ParametersTableViewCellProtocol {
    
    // MARK: - UI Views
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .AppColors.black
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: CheckmarkCellView.self)
    
    // MARK: - View Model
    
    private var viewModel: CheckmarkCellViewModel?
    
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

    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: CheckmarkCellViewModel) {
        self.viewModel = viewModel
        updateView()
    }
    
    // MARK: - UI Updates
    
    func didSelect() {
        viewModel?.updateModel(isSelected)
    }
    
    private func updateView() {
        guard let viewModel else { return }
        
        titleLabel.text = viewModel.title
        accessoryType = viewModel.isSelected ? .checkmark : .none
    }
    
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
