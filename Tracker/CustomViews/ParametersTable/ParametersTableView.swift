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
    
    // MARK: - Internal Properties
    
    var selectedValue: Any?
    var selectionAction: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var parameterCells: [ParametersTableViewCellProtocol] = []
    private var selectedCell: CheckmarkTableViewCell? {
        didSet {
            selectedValue = selectedCell?.title
            selectionAction?()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .AppColors.background
        isScrollEnabled = false
        
        // Удаление верхнего сепаратора.
        tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 1)
        )
        
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
        register(
            CheckmarkTableViewCell.self,
            forCellReuseIdentifier: CheckmarkTableViewCell.reuseIdentifier
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
        } else if
            let cell = tableView.cellForRow(at: indexPath) as? CheckmarkTableViewCell
        {
            selectedCell?.isChecked = false
            cell.isChecked = true
            selectedCell = cell
        }
    }
    
    // На будущее. Создание контекстного меню.
    // func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPaths: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { }
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
        
        // TODO: Переписать установку выбранного значения по-нормальному.
        if
            let checkmarkCell = cell as? CheckmarkTableViewCell,
            let selectedValue = selectedValue as? String,
            checkmarkCell.title == selectedValue
        {
            checkmarkCell.isChecked = true
        }
        
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
