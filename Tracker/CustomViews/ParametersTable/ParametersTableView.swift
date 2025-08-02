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
            ButtonCellView.self,
            forCellReuseIdentifier: ButtonCellView.reuseIdentifier
        )
        register(
            SwitcherCellView.self,
            forCellReuseIdentifier: SwitcherCellView.reuseIdentifier
        )
        register(
            CheckmarkCellView.self,
            forCellReuseIdentifier: CheckmarkCellView.reuseIdentifier
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
    
    func updateParameters( _ viewModels: [SwitcherCellViewModel]?) {
        guard let viewModels else { return }
        parameterCells.removeAll()
        viewModels.forEach { [weak self] viewModel in
            let switcherCellView = SwitcherCellView()
            switcherCellView.setViewModel(viewModel)
            self?.parameterCells.append(switcherCellView)
        }
        reloadData()
    }
    
    func updateParameters( _ viewModels: [CheckmarkCellViewModel]?) {
        guard let viewModels else { return }
        parameterCells.removeAll()
        viewModels.forEach { [weak self] viewModel in
            let checkmarkCellViewModel = CheckmarkCellView()
            checkmarkCellViewModel.setViewModel(viewModel)
            self?.parameterCells.append(checkmarkCellViewModel)
        }
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
            let cell = tableView.cellForRow(at: indexPath) as? ButtonCellView,
            let action = cell.tapAction
        {
            action()
        } else if
            let cell = tableView.cellForRow(at: indexPath) as? CheckmarkCellView
        {
            cell.didSelect()
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
        
        if indexPath.row == parameterCells.count - 1 {
            // Удаление последнего сепаратора.
            cell.separatorInset = UIEdgeInsets.init(
                top: 0,
                left: cell.frame.width * 2,
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
