import UIKit

final class TrackersCollectionView: UICollectionView {
    
    var categories: [TrackerCategory] = []  // Не рекомендуется менять массив, лучше
                                            // при создании новой категории создавать
                                            // новый массив.
    var completedTrackers: [TrackerRecord] = []
    
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
        
        // Флаг, сообщающий, поддерживается множественный выбор или нет.
        // Добавил на случай, если понадобится в проекте.
        // allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TrackersCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        0
    } // Возвращать количество элементов в указанной секции.
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        UICollectionViewCell()
    } // Возвращать ячейкку с указанным индесом. Тут же можно ее обновлят
    
}

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
            header.title = "Загловок"
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
    // Без ячеек этот метод пока валится.
    // Он определяет размер хэдера.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
     */
    
    // Без ячеек этот метод пока валится.
    // Система сама настривает размер ячейки исходя из контента.
    // Если есть требование расположить в строке определенное кол-во
    // ячеек, их размер нужно задать самостоятельно в этом методе.
    // В данном примере он задается относительно ширины коллекции,
    // т.е. берется половина от величины.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 50)
    }
     */
    
    // Без ячеек этот метод пока валится.
    // Задает минимальный отступ между ячейками.
    /*
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
     */
}
