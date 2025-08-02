import UIKit

final class SelectorCollectionView: UICollectionView {

    // MARK: - Internal Properties

    var title: String = NSLocalizedString("defaultTitle", comment: "Default title")
    
    private(set) var selectedValue: Any?
    var selectionAction: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var geometryParameters: GeometryParameters?
    private var values: [Any] = []
    
    // MARK: - Initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        isScrollEnabled = false
        allowsMultipleSelection = false
        
        geometryParameters = GeometryParameters(
            cellCount: 6,
            sectionInsets: UIEdgeInsets(
                top: 12,
                left: ScreenType.shared.isWithIsland ? 18 : 16,
                bottom: 24,
                right: ScreenType.shared.isWithIsland ? 18 : 16),
            cellSpacing: CGPoint(x: ScreenType.shared.isWithIsland ? 5 : 0, y: 0),
            cellHeightToWidthRatio: 1
        )
        
        dataSource = self
        delegate = self
        
        register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier
        )
        register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier
        )
        
        register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Internal Methods
    
    func addValues(_ values: [Character]?) {
        addSection(values)
    }
    
    func addValues(_ values: [UIColor]?) {
        addSection(values)
    }
    
    func estimatHeight(for viewRect: CGRect) -> CGFloat {
        guard let geometryParameters else { return 0 }
        
        let cellHeight = geometryParameters.calcCellSize(for: viewRect).height
        let sectionYPadding = geometryParameters.sectionInsets.top + geometryParameters.sectionInsets.bottom
        let cellYSpacing = geometryParameters.cellSpacing.y
        let rowsNum = ceil(CGFloat(values.count) / CGFloat(geometryParameters.cellCount))
        
        var height = HeaderView.defaultHeight
        height += cellHeight * rowsNum + cellYSpacing * (rowsNum - 1)
        height += sectionYPadding
    
        return height
    }
    
    // MARK: - Private Methods
    
    private func addSection(_ values: [Any]?) {
        guard let values else { return }
        values.forEach { self.values.append($0) }
    }
}

extension SelectorCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { values.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellData = values[indexPath.item]
        
        switch cellData {
        case is Character:
            guard
                let cell = dequeueReusableCell(
                    withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? CharacterCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.character = cellData as? Character
            return cell
        case is UIColor:
            guard
                let cell = dequeueReusableCell(
                    withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? ColorCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.color = cellData as? UIColor
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension SelectorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView
        {
            header.title = title
            return header
        }
        
        return UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedValue = values[indexPath.item]
        selectionAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: HeaderView.defaultHeight
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
