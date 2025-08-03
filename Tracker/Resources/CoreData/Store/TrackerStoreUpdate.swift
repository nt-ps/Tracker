import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let movedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
}
