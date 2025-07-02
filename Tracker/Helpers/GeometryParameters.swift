import UIKit

struct GeometryParameters {
    let cellCount: Int
    let sectionInsets: UIEdgeInsets
    let cellSpacing: CGPoint
    let cellHeightToWidthRatio: CGFloat
    
    private let availableWidth: CGFloat
    
    init(cellCount: Int, sectionInsets: UIEdgeInsets, cellSpacing: CGPoint, cellHeightToWidthRatio: CGFloat) {
        self.cellCount = cellCount
        self.sectionInsets = sectionInsets
        self.cellSpacing = cellSpacing
        self.cellHeightToWidthRatio = cellHeightToWidthRatio
        
        self.availableWidth = sectionInsets.left + sectionInsets.right + CGFloat(cellCount - 1) * cellSpacing.x
    }
    
    func calcCellSize(for viewRect: CGRect) -> CGSize {
        let availableWidth = viewRect.width - availableWidth
        let cellWidth = availableWidth / CGFloat(cellCount)
        let cellHeight = cellWidth * cellHeightToWidthRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
