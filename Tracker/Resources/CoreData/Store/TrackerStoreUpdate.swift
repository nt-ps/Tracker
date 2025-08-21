import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let movedIndexes: [(IndexPath, IndexPath)]
    let updatedIndexes: [IndexPath]
}
