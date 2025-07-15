import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackersByCategory: [TrackerCategory] {
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
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

    private var insertedIndexes: IndexSet = IndexSet()
    
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

    func setFetchRequest(for date: Date) {
        var dayNumber = Calendar.current.component(.weekday, from: date)
        dayNumber = dayNumber - 1 < 1 ? 7 : dayNumber - 1
        
        fetchedResultsController?.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[n] %@",
            #keyPath(TrackerCoreData.type),
            "\(dayNumber)"
        )
        
        try? fetchedResultsController?.performFetch()
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        guard let categoryCoreData = try? getCategoryCoreData(categoryTitle) else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
        categoryCoreData.addToTrackers(trackerCoreData)
        try context.save()
    }

    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color.toHexString()
        trackerCoreData.emoji = String(tracker.emoji)
        trackerCoreData.type = tracker.type.toString()
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
            throw TrackerCategoryStoreError.couldNotGetContext
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
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerStoreUpdate(insertedIndexes: insertedIndexes)
        )
        insertedIndexes.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
