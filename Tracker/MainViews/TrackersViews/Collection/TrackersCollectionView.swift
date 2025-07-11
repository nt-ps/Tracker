import UIKit

final class TrackersCollectionView: UICollectionView {

    // MARK: - Internal Properties
    
    weak var navigationItem: TrackersNavigationItem?
    
    var categories: [TrackerCategory] = []
    var completedTrackers = Set<TrackerRecord>()
    
    // MARK: - Private Properties
    
    private var geometryParameters: GeometryParameters?
    
    // MARK: - Initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        geometryParameters = GeometryParameters(
            cellCount: 2,
            sectionInsets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
            cellSpacing: CGPoint(x: 8, y: 0),
            cellHeightToWidthRatio: 149.0 / 167.0
        )
        
        dataSource = self
        delegate = self
        
        register(
            TrackersCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier
        )
        register(
            TrackersHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackersHeaderView.reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Updates
    
    private func configCell(with indexPath: IndexPath) {
        guard let tracker = getTracker(with: indexPath) else { return }
        configCell(with: indexPath, from: tracker)
    }
    
    private func configCell(with indexPath: IndexPath, from tracker: Tracker) {
        guard
            let cell = cellForItem(at: indexPath) as? TrackersCollectionViewCell
        else { return }
        configCell(cell, from: tracker)
    }
    
    private func configCell(for cell: TrackersCollectionViewCell, with indexPath: IndexPath) {
        guard let tracker = getTracker(with: indexPath) else { return }
        configCell(cell, from: tracker)
    }
    
    private func configCell(_ cell: TrackersCollectionViewCell, from tracker: Tracker) {
        guard let navigationItem else { return }
        let isDone = findRecord(for: tracker, inDay: navigationItem.selectedDate) != nil
        configCell(cell, from: tracker, isDone: isDone)
    }
    
    private func configCell(
        _ cell: TrackersCollectionViewCell,
        from tracker: Tracker,
        isDone: Bool
    ) {
        cell.color = tracker.color
        cell.emoji = tracker.emoji
        cell.name = tracker.name
        cell.isDone = isDone
        
        let daysNum = completedTrackers.count { record in
            record.trackerId == tracker.id
        }
        cell.daysNumber = daysNum
    }
    
    // MARK: - Private methods
    
    private func getTracker(with indexPath: IndexPath) -> Tracker? {
        categories[indexPath.section].trackers[indexPath.item]
    }
    
    private func findRecord(for tracker: Tracker, inDay date: Date) -> TrackerRecord? {
        completedTrackers.first { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}

extension TrackersCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { categories[0].trackers.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let trackerCell = cell as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }

        configCell(for: trackerCell, with: indexPath)
        trackerCell.delegate = self
        
        return trackerCell
    }
}

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackersHeaderView.reuseIdentifier,
                for: indexPath
            ) as? TrackersHeaderView
        {
            header.title = categories[indexPath.section].title
            return header
        }
        
        return UICollectionViewCell()
    }

    // На будущее. Метод выделения ячейки.
    // func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    
    // На будущее. Метод снятия выделения.
    // func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { }
    
    // На будущее. Метод вызова контекстного меню.
    //func collectionView(_ collectionView: UICollectionView,contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? { }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: TrackersHeaderView.defaultHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        geometryParameters?.calcCellSize(for: collectionView.frame) ?? .zero
    }
     
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets { geometryParameters?.sectionInsets ?? .zero }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { geometryParameters?.cellSpacing.y ?? 0 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { geometryParameters?.cellSpacing.x ?? 0 }
}

extension TrackersCollectionView: TrackersCollectionViewCellDelegate {
    func trackerCellDoneButtonDidTap(_ cell: TrackersCollectionViewCell) {
        guard
            let indexPath = indexPath(for: cell),
            let tracker = getTracker(with: indexPath),
            let date = navigationItem?.selectedDate
        else { return }
        
        if date > Date() {
            return
        }

        if let record = findRecord(for: tracker, inDay: date) {
            completedTrackers.remove(record)
            configCell(cell, from: tracker, isDone: false)
        } else {
            let record = TrackerRecord(trackerId: tracker.id, date: date )
            completedTrackers.insert(record)
            configCell(cell, from: tracker, isDone: true)
        }
    }
}
