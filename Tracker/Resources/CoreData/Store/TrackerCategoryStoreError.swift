enum TrackerCategoryStoreError: Error {
    case couldNotGetContext
    case categoryAlreadyExists
    case categoryNotFound
    case failedToDecodeFields
}
