import CoreData
import UIKit

final class TrackerRecordStore {
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    var records: Set<TrackerRecord> {
        var records = Set<TrackerRecord>()
        
        guard let context else { return records }
    
        let request = NSFetchRequest<TrackerRecordCoreData>(
            entityName: String(describing: TrackerRecordCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        
        guard let recordsCoreData = try? context.fetch(request) else { return records }
        
        recordsCoreData.forEach{
            if let record = try? createTrackerRecord(from: $0) {
                records.insert(record)
            }
        }
        
        return records
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext?

    // MARK: - Initializers
    
    convenience init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext?) {
        self.context = context
    }
    
    // MARK: - Internal Methods
    
    func addRecord(_ record: TrackerRecord) throws {
        guard let context else {
            throw TrackerRecordStoreError.couldNotGetContext
        }
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = record.date
        guard let trackerCoreData = try? getTrackerCoreData(record.trackerId) else {
            throw TrackerRecordStoreError.trackerNotFound
        }
        trackerRecordCoreData.tracker = trackerCoreData
        try context.save()
    }
    
    func deleteRecord(_ record: TrackerRecord) throws {
        guard let context else {
            throw TrackerRecordStoreError.couldNotGetContext
        }

        guard
            let recordCoreData = try getRecordCoreData(for: record)
        else {
            throw TrackerRecordStoreError.recordNotFound
        }

        context.delete(recordCoreData)
        try context.save()
    }

    
    // MARK: - Private Methods
    
    private func createTrackerRecord(
        from trackerRecordCoreData: TrackerRecordCoreData
    ) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.tracker?.trackerId,
            let date = trackerRecordCoreData.date
        else {
            throw TrackerRecordStoreError.failedToDecodeFields
        }
        
        return TrackerRecord(trackerId: id, date: date)
    }
    
    private func getTrackerCoreData(_ id: UUID) throws -> TrackerCoreData? {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        let request = NSFetchRequest<TrackerCoreData>(
            entityName: String(describing: TrackerCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId),
            "\(id)"
        )
        
        let trackers = try context.fetch(request)
        return trackers.first
    }
    
    private func getRecordCoreData(for record: TrackerRecord) throws -> TrackerRecordCoreData? {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        let request = NSFetchRequest<TrackerRecordCoreData>(
            entityName: String(describing: TrackerRecordCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordCoreData.tracker.trackerId),
            "\(record.trackerId)",
            #keyPath(TrackerRecordCoreData.date),
            record.date as CVarArg
        )
        
        return try context.fetch(request).first
    }
}
