import CoreData
import UIKit

final class TrackerStore: NSObject, TrackersSourceProtocol {
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackersByCategory: [TrackerCategory] {
        // Добавил на случай, когда поменялся заголовок категории,
        // Чтобы при обновлении до коллекции дошло новое имя.
        try? fetchedResultsController?.performFetch()
        
        guard let categories = fetchedResultsController?.sections else { return [] }
    
        let trackerCategories = categories.map {
            let title = $0.name
            let trackers: [Tracker]? = $0.objects?.reduce(
                into: []
            ) { (result, data) in
                if
                    let trackerCoreData = data as? TrackerCoreData,
                    let tracker = try? createTracker(from: trackerCoreData)
                {
                    result.append(tracker)
                }
            }
            return TrackerCategory(title: title, trackers: trackers ?? [])
        }
        
        return trackerCategories
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>? = {
        guard let context else { return nil }
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(
            entityName: String(describing: TrackerCoreData.self)
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: false),
            NSSortDescriptor(key: "name", ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()

        return fetchedResultsController
    } ()

    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var movedIndexes: [(IndexPath, IndexPath)] = []
    private var updatedIndexes: [IndexPath] = []
    
    // MARK: - Initializers
    
    convenience override init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext?) {
        self.context = context
    }
    
    // MARK: - Internal Methods

    func setFetchRequest(for filter: Filter) {
        var dayNumber = Calendar.current.component(.weekday, from: filter.date)
        dayNumber = dayNumber - 1 < 1 ? 7 : dayNumber - 1
        
        var predicate = NSPredicate(
            format: "%K CONTAINS[n] %@",
            #keyPath(TrackerCoreData.type),
            "\(dayNumber)"
        )
        
        if let isFinished = filter.isFinished {
            guard
                let startOfDay = Calendar.current.date(
                    from: Calendar.current.dateComponents([.year, .month, .day], from: filter.date)
                ),
                let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
            else { return }
            
            let predicateForStartOfDay = NSPredicate(
                format: "ANY %K.%K >= %@",
                #keyPath(TrackerCoreData.records),
                #keyPath(TrackerRecordCoreData.date),
                startOfDay as CVarArg
            )
            let predicateForEndOfDay = NSPredicate(
                format: "ANY %K.%K < %@",
                #keyPath(TrackerCoreData.records),
                #keyPath(TrackerRecordCoreData.date),
                endOfDay as CVarArg
            )
            
            var completionPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [predicateForStartOfDay, predicateForEndOfDay]
            )
            
            if !isFinished {
                let isEmptyPredicate = NSPredicate(
                    format: "%K.@count < 1",
                    #keyPath(TrackerCoreData.records)
                )
                
                completionPredicate = NSCompoundPredicate(notPredicateWithSubpredicate: completionPredicate)
                completionPredicate = NSCompoundPredicate(
                    orPredicateWithSubpredicates: [isEmptyPredicate, completionPredicate]
                )
            }
            
            predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [predicate, completionPredicate]
            )
        }
        
        if let name = filter.name {
            let namePredicate = NSPredicate(
                format: "%K CONTAINS[cd] %@",
                #keyPath(TrackerCoreData.name),
                name
            )
            predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [predicate, namePredicate]
            )
        }
        
        fetchedResultsController?.fetchRequest.predicate = predicate
        
        try? fetchedResultsController?.performFetch()
    }
    
    func saveTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        
        let trackerCoreData = try getTrackerCoreData(tracker) ?? TrackerCoreData(context: context)
        try updateExistingTracker(trackerCoreData, with: tracker, category: categoryTitle)
        
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        
        guard let trackerCoreData = try? getTrackerCoreData(tracker) else {
            throw TrackerStoreError.trackerNotFound
        }
        
        context.delete(trackerCoreData)
        
        let records = trackerCoreData.records?.allObjects as? [TrackerRecordCoreData]
        records?.forEach { context.delete($0) }
        
        try context.save()
    }

    func updateExistingTracker(
        _ trackerCoreData: TrackerCoreData,
        with tracker: Tracker,
        category: String
    ) throws {
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color.toHexString()
        trackerCoreData.emoji = String(tracker.emoji)
        trackerCoreData.type = tracker.type.toString()
        
        guard let categoryCoreData = try getCategoryCoreData(category) else {
            throw TrackerStoreError.categoryNotFound
        }
        categoryCoreData.addToTrackers(trackerCoreData)
    }
    
    // MARK: - Private Methods
    
    private func createTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = trackerCoreData.trackerId,
            let name = trackerCoreData.name,
            let colorString = trackerCoreData.color,
            let color = UIColor(hexaDecimalString: colorString),
            let emoji = trackerCoreData.emoji?.first,
            let typeString = trackerCoreData.type
        else {
            throw TrackerStoreError.failedToDecodeFields
        }
        
        let type = TrackerType(from: typeString)
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, type: type)
    }
    
    // Дублировал этот метод из TrackerCategoryCoreData по след. причинам:
    // - Он мне тут нужен для создания связи;
    // - По заданию должны быть добавлены TrackerStore и TrackerCategoryCoreData отдельно;
    // - Не хочу вытаскивать в public или internal методы, которые возвращают
    //   объекты CoreData. Тогда они будут торчать наружу и могут изменяться где попало,
    //   это не хорошо.
    private func getCategoryCoreData(_ title: String) throws -> TrackerCategoryCoreData? {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(
            entityName: String(describing: TrackerCategoryCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            title
        )

        return try context.fetch(request).first
    }
    
    private func getTrackerCoreData(_ tracker: Tracker) throws -> TrackerCoreData? {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        
        let request = NSFetchRequest<TrackerCoreData>(
            entityName: String(describing: TrackerCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId),
            "\(tracker.id)"
        )

        return try context.fetch(request).first
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes.removeAll()
        deletedIndexes.removeAll()
        movedIndexes.removeAll()
        updatedIndexes.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                movedIndexes: movedIndexes,
                updatedIndexes: updatedIndexes
            )
        )
        insertedIndexes.removeAll()
        deletedIndexes.removeAll()
        movedIndexes.removeAll()
        updatedIndexes.removeAll()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes.append(indexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexes.append(indexPath)
            }
        case .move:
            if let indexPath, let newIndexPath {
                movedIndexes.append((indexPath, newIndexPath))
            }
        case .update:
            if let indexPath {
                updatedIndexes.append(indexPath)
            }
        default:
            break
        }
    }
}
