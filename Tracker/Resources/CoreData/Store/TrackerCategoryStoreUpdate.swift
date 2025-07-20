import Foundation

struct TrackerCategoryStoreUpdate {
    let insertedIndexes: IndexSet
    // TODO: Bзменения могут повторять TrackerStoreUpdate.
    // Подумать над вводом единой структуры для обоих хранилищ.
}
