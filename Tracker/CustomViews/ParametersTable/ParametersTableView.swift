import UIKit

final class ParametersTableView: UITableView {
    
    // MARK: - Overrided Properties
    
    // Для вычисления высоты таблицы относительно содержимого.
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    // Для вычисления высоты таблицы относительно содержимого.
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentSize.height + adjustedContentInset.top
        )
    }
    
    // MARK: - Private Properties
    
    private var parameterCells: [ParametersTableViewCellProtocol] = []
    
    // MARK: - Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        layer.masksToBounds = true
        layer.cornerRadius = 16 // TODO: Использовать базовую единицу.
        backgroundColor = .AppColors.lightGray
        isScrollEnabled = false
        tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 1)
        ) // Удаление верхнего сепаратора.
        
        delegate = self
        dataSource = self

        register(
            ButtonTableViewCell.self,
            forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier
        )
        register(
            SwitchTableViewCell.self,
            forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("ParametersTableView.init(coder:) has not been implemented")
    }
    
    // MARK: - UI Updates
    
    func updateParameters(_ parameters: [ParametersTableViewCellProtocol]) {
        parameterCells = parameters
        reloadData()
    }
}

extension ParametersTableView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat { 75 }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        if
            let cell = tableView.cellForRow(at: indexPath) as? ButtonTableViewCell,
            let action = cell.tapAction
        {
            action()
        }
    }
}

extension ParametersTableView: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int { parameterCells.count }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let index = indexPath.row
        let cell = parameterCells[index]
        
        if indexPath.row == parameterCells.count - 1 {
            // Удаление последнего сепаратора.
            cell.separatorInset = UIEdgeInsets.init(
                top: 0,
                left: cell.frame.width,
                bottom: 0,
                right: 0
            )
        } else {
            cell.separatorInset = UIEdgeInsets.init(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            )
        }

        return cell
    }
}
