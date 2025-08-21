final class StatisticsService {
    var isDataValid: Bool { trackerStore.trackersNumber > 0}
    var finishedNumber: Int { trackerRecordStore.records.count }
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
}
