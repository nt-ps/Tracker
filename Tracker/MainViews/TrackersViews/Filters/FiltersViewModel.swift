import Foundation

final class FiltersViewModel {
    
    // MARK: - Bindings
    
    var onFilterStateChange: Binding<Filter>?
    
    // MARK: - Internal Properties
    
    let viewTitle = NSLocalizedString(
        "filtersView.title",
        comment: "Filters view title"
    )
    
    let allTrackersButtonTitle = NSLocalizedString(
        "filtersView.allTrackersButtonTitle",
        comment: "All trackers button title"
    )

    let trackersForTodayButtonTitle = NSLocalizedString(
        "filtersView.trackersForTodayButtonTitle",
        comment: "Trackers for today button title"
    )
    
    let finishedTrackersCheckmarkTitle = NSLocalizedString(
        "filtersView.finishedTrackersCheckmarkTitle",
        comment: "Finished trackers checkmark title"
    )
    
    let unfinishedTrackersCheckmarkTitle = NSLocalizedString(
        "filtersView.unfinishedTrackersCheckmarkTitle",
        comment: "Unfinished trackers checkmark title"
    )
    
    lazy var isFinishedCheckmarkSelected: Bool = model.isFinished ?? false
    
    lazy var isUnfinishedCheckmarkSelected: Bool = !(model.isFinished ?? true)
    
    // MARK: - Model
    
    private var model: Filter
    
    // MARK: - Initializers
    
    init(for model: Filter) {
        self.model = model
    }
    
    // MARK: - Internal Methods
    
    func setAllTrackersFilter() {
        model.allFor(model.date)
        onFilterStateChange?(model)
    }
    
    func setForTodayFilter() {
        model.reset()
        onFilterStateChange?(model)
    }
    
    func setFinishedFilter() {
        model.finishedFor(model.date)
        onFilterStateChange?(model)
    }
    
    func setUnfinishedFilter() {
        model.unfinishedFor(model.date)
        onFilterStateChange?(model)
    }
}
