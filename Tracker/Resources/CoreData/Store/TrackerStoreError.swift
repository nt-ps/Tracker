enum TrackerStoreError: Error {
    case couldNotGetContext
    case failedToDecodeFields
    case categoryNotFound
    case trackerNotFound
}
