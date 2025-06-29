import UIKit

final class TrackersCollectionView: UICollectionView {
    
    var categories: [TrackerCategory] = []  // Не рекомендуется менять массив, лучше
                                            // при создании новой категории создавать
                                            // новый массив.
    var completedTrackers: [TrackerRecord] = []
    
    private var geometryParameters: GeometryParameters?
    
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
        
        // Флаг, сообщающий, поддерживается множественный выбор или нет.
        // Добавил на случай, если понадобится в проекте.
        // allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// TODO: Лучше вынести датасурс в отдельный класс.
// Он должен наследоваться от NSObject и UICollectionViewDataSource.
extension TrackersCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        3
    } 
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath)
                
        guard let trackerCell = cell as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        trackerCell.prepareForReuse()
        
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
