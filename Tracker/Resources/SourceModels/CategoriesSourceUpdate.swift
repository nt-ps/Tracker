import Foundation

struct CategoriesSourceUpdate {
    let insertedIndexes: IndexSet
    // TODO: Изменения могут повторять TrackerStoreUpdate.
    // Подумать над вводом единой структуры для обоих хранилищ.
}
