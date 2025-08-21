protocol TrackersSourceProtocol {
    func saveTracker(_ tracker: Tracker, to categoryTitle: String) throws
    func deleteTracker(_ tracker: Tracker) throws
}
