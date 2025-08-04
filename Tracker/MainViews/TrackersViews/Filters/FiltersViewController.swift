
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
        allTrackersButton.title = NSLocalizedString(
            "filtersView.allTrackersButtonTitle",
            comment: "All trackers button title"
        )
        allTrackersButton.isAccessoryHidden = true
        // allTrackersButton.tapAction = showCategories
        return allTrackersButton
    } ()
    
    private lazy var trackersForTodayButton: ButtonCellView = {
        let trackersForTodayButton = ButtonCellView()
        trackersForTodayButton.title = NSLocalizedString(
            "filtersView.trackersForTodayButtonTitle",
            comment: "Trackers for today button title"
        )
        trackersForTodayButton.isAccessoryHidden = true
        // trackersForTodayButton.tapAction = showCategories
        return trackersForTodayButton
    } ()
    
    private lazy var finishedTrackersCheckmark: CheckmarkCellView = {
        let finishedTrackersCheckmark = CheckmarkCellView()
        let title = NSLocalizedString(
            "filtersView.finishedTrackersCheckmarkTitle",
            comment: "Finished trackers checkmark title"
        )
        let viewModel = CheckmarkCellViewModel(
            title: title,
            value: false,
            isSelected: false,
            selectAction: nil
        )
        finishedTrackersCheckmark.setViewModel(viewModel)
        return finishedTrackersCheckmark
    } ()
    
    private lazy var unfinishedTrackersCheckmark: CheckmarkCellView = {
        let unfinishedTrackersCheckmark = CheckmarkCellView()
        let title = NSLocalizedString(
            "filtersView.unfinishedTrackersCheckmarkTitle",
            comment: "Unfinished trackers checkmark title"
        )
        let viewModel = CheckmarkCellViewModel(
            title: title,
            value: false,
            isSelected: false,
            selectAction: nil
        )
        unfinishedTrackersCheckmark.setViewModel(viewModel)
        return unfinishedTrackersCheckmark
    } ()
    
    // MARK: - UI Properties
    
    private let tableItemXSpacing = 16.0
    private let tableItemYSpacing = 24.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString(
            "filtersView.title",
            comment: "Filters view title"
        )
        navigationItem.setHidesBackButton(true, animated: true)

        view.addSubview(filtersTableView)
        setConstraints()
    }
    
    // MARK: - UI Actions
    
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
