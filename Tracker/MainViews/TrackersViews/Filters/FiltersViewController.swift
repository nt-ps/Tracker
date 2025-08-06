
import UIKit

final class FiltersViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var filtersTableView: ParametersTableView = {
        let filtersTableView = ParametersTableView()
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters: [ParametersTableViewCellProtocol] = [
            allTrackersButton,
            trackersForTodayButton,
            finishedTrackersCheckmark,
            unfinishedTrackersCheckmark
        ]
        filtersTableView.updateParameters(parameters)
        return filtersTableView
    } ()

    private lazy var allTrackersButton: ButtonCellView = {
        let allTrackersButton = ButtonCellView()
        allTrackersButton.title = viewModel?.allTrackersButtonTitle
        allTrackersButton.isAccessoryHidden = true
        allTrackersButton.tapAction = { [weak self] in
            self?.viewModel?.setAllTrackersFilter()
        }
        return allTrackersButton
    } ()
    
    private lazy var trackersForTodayButton: ButtonCellView = {
        let trackersForTodayButton = ButtonCellView()
        trackersForTodayButton.title = viewModel?.trackersForTodayButtonTitle
        trackersForTodayButton.isAccessoryHidden = true
        trackersForTodayButton.tapAction = { [weak self] in
            self?.viewModel?.setForTodayFilter()
        }
        return trackersForTodayButton
    } ()
    
    private lazy var finishedTrackersCheckmark: CheckmarkCellView = {
        let finishedTrackersCheckmark = CheckmarkCellView()
        let title = viewModel?.finishedTrackersCheckmarkTitle
        let viewModel = CheckmarkCellViewModel(
            title: title,
            value: false,
            isSelected: viewModel?.isFinishedCheckmarkSelected ?? false,
            selectAction: { [weak self] _ in
                self?.viewModel?.setFinishedFilter()
            }
        )
        finishedTrackersCheckmark.setViewModel(viewModel)
        return finishedTrackersCheckmark
    } ()
    
    private lazy var unfinishedTrackersCheckmark: CheckmarkCellView = {
        let unfinishedTrackersCheckmark = CheckmarkCellView()
        let title = viewModel?.unfinishedTrackersCheckmarkTitle
        let viewModel = CheckmarkCellViewModel(
            title: title,
            value: false,
            isSelected: viewModel?.isUnfinishedCheckmarkSelected ?? false,
            selectAction: { [weak self] _ in
                self?.viewModel?.setUnfinishedFilter()
            }
        )
        unfinishedTrackersCheckmark.setViewModel(viewModel)
        return unfinishedTrackersCheckmark
    } ()
    
    // MARK: - UI Properties
    
    private let tableItemXSpacing = 16.0
    private let tableItemYSpacing = 24.0
    
    // MARK: - View Model
    
    private var viewModel: FiltersViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewModel?.viewTitle
        navigationItem.setHidesBackButton(true, animated: true)

        view.addSubview(filtersTableView)
        setConstraints()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: FiltersViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI Updates

    private func setConstraints() {
        NSLayoutConstraint.activate([
            filtersTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: tableItemXSpacing
            ),
            filtersTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: tableItemYSpacing
            ),
            filtersTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -tableItemXSpacing
            ),
            filtersTableView.bottomAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}
