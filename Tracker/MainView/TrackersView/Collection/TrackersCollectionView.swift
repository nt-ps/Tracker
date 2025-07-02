import UIKit

final class TrackersCollectionView: UICollectionView, TrackersCollectionViewProtocol {
    
    // MARK: - Trackers Collection View Protocol Properties
    
    var navigator: (any TrackersNavigatorItemProtocol)?
    
    // MARK: - Internal Properties
    
    var categories: [TrackerCategory] = []  // Не рекомендуется менять массив, лучше
                                            // при создании новой категории создавать
                                            // новый массив.
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
    
    private var geometryParameters: GeometryParameters?
    
    // MARK: - Overrided methods
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
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
        
        // TODO: Вынести базовую единицу 8 в глобальные константы, и использовать тут.
        geometryParameters = GeometryParameters(
            cellCount: 2,
            sectionInsets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
            cellSpacing: CGPoint(x: 8, y: 0),
            cellHeightToWidthRatio: 149.0 / 167.0
        )
        
        // Mock.
        categories = TrackersDataMock.share.data
        
        // Флаг, сообщающий, поддерживается множественный выбор или нет.
        // Добавил на случай, если понадобится в проекте.
        // allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Trackers Collection View Protocol Properties
    
    func updateTrackersCollection() {
        // TODO: Метод написан "на скорую руку".
        // Переписать нормально.
        guard let date = navigator?.selectedDate else { return }
        
        let data = TrackersDataMock.share.data
        
        let newData: [TrackerCategory] = data.reduce(into: [], { (result, category) in
            let newTrackers: [Tracker] = category.trackers.reduce(into: [], { (result, tracker) in
                var dayNumber = Calendar.current.component(.weekday, from: date)
                dayNumber = dayNumber - 1 < 1 ? 7 : dayNumber - 1
                switch tracker.type {
                case .event:
                    result.append(tracker)
                case .habit(let schedule):
                    if schedule.contains(dayNumber: dayNumber) {
                        result.append(tracker)
                    }
                }
            })
            
            if !newTrackers.isEmpty {
                let newCategory = TrackerCategory(
                    title: category.title,
                    trackers: newTrackers
                )
                result.append(newCategory)
            }
        })
        
        if newData.isEmpty {
            navigator?.showStub()
        }
        
        categories = newData
        reloadData()
    }
    
    func close() {
        self.willMove(toSuperview: nil)
        self.removeFromSuperview()
    }
    
    // MARK: - UI Updates
    
    private func configCell(with indexPath: IndexPath) {
        guard let tracker = getTracker(with: indexPath) else { return }
        configCell(with: indexPath, from: tracker)
    }
    
    private func configCell(with indexPath: IndexPath, from tracker: Tracker) {
        guard let cell = cellForItem(at: indexPath) as? TrackersCollectionViewCell else { return }
        configCell(cell, from: tracker)
    }
    
    private func configCell(for cell: TrackersCollectionViewCell, with indexPath: IndexPath) {
        guard let tracker = getTracker(with: indexPath) else { return }
        configCell(cell, from: tracker)
    }
    
    private func configCell(_ cell: TrackersCollectionViewCell, from tracker: Tracker) {
        guard let navigator else { return }
        let isDone = findRecordIndex(for: tracker, inDay: navigator.selectedDate) != nil
        configCell(cell, from: tracker, isDone: isDone)
    }
    
    private func configCell(_ cell: TrackersCollectionViewCell, from tracker: Tracker, isDone: Bool) {
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
    
    private func findRecordIndex(for tracker: Tracker, inDay date: Date) -> Int? {
        completedTrackers.firstIndex { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}

// TODO: Лучше вынести датасурс в отдельный класс.
// Он должен наследоваться от NSObject и UICollectionViewDataSource.
extension TrackersCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categories[0].trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath)
        
        guard let trackerCell = cell as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // trackerCell.prepareForReuse()
        configCell(for: trackerCell, with: indexPath)
        trackerCell.delegate = self
        
        return trackerCell
    }
}

// TODO: UICollectionViewDelegateFlowLayout - это потомок UICollectionViewDelegate.
// Следовательно все методы последнего можно перенести в первый.
extension TrackersCollectionView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackersHeaderView.reuseIdentifier,
                for: indexPath
            ) as! TrackersHeaderView
            header.title = "Заголовок"
            return header
        }
        
        return UICollectionViewCell()
    }

    
    // Метод выделения ячейки. Добавил на случай, если понадобится в проекте.
    // Если заданная ячейка выделена, то можно изменить
    // ее внешний вид, например.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
    }
     */
    
    // Метод снятия выделения. Добавил на случай, если понадобится в проекте.
    // Принцип аналогичный, только когда выделение снимается.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
    }
     */
    
    // Метод вызова контекстного меню.
    // Добавил на случай, если понадобится в проекте.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "") { [weak self] _ in
                    // Action
                },
                UIAction(title: "") { [weak self] _ in
                    // Action
                },
            ])
        })
    }
     */
}

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    // Определяет размер хэдера/футера.
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
    
    // Система сама настривает размер ячейки исходя из контента.
    // Если есть требование расположить в строке определенное кол-во
    // ячеек, их размер нужно задать самостоятельно в этом методе.
    // В данном примере он задается относительно ширины коллекции,
    // т.е. берется половина от величины.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { geometryParameters?.calcCellSize(for: collectionView.frame) ?? .zero }
     
    // Задает отступы секции от краев коллекции.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets { geometryParameters?.sectionInsets ?? .zero }
    
    // Задает вертикальный отступ между ячейками.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { geometryParameters?.cellSpacing.y ?? 0 }
    
    
    // Задает горизонтальный отступ между ячейками.
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
            let date = navigator?.selectedDate
        else { return }
        
        if date > Date() {
            return
        }

        if let recordIndex = findRecordIndex(for: tracker, inDay: date) {
            completedTrackers.remove(at: recordIndex)
            configCell(cell, from: tracker, isDone: false)
        } else {
            let record = TrackerRecord(trackerId: tracker.id, date: date )
            completedTrackers.append(record)
            configCell(cell, from: tracker, isDone: true)
        }
    }
}
