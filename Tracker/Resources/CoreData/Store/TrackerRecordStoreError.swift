enum TrackerRecordStoreError: Error {
    case couldNotGetContext
    case failedToDecodeFields
    case trackerNotFound
    case recordNotFound
}
