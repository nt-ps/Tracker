import CoreData
import UIKit

// TODO: Вынести в отдельный файл.
struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    // TODO: В будущем помещать сюда остальные изменения типа удаления, перемещения и т.д.
}

// TODO: Вынести в отдельный файл.
protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
    
    // MARK: - Internal Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let categories = fetchedResultsController?.sections
        else { return [] }
        
        let obj = categories.first?.objects?.first as? TrackerCoreData
        let id1 = obj?.id
        let name1 = obj?.name
        let color1 = obj?.color
        let emoji1 = obj?.emoji
        let type1 = obj?.type
    
        let trackerCategories = categories.map {
            let title = $0.name
            //let trackersCoreData = $0.objects as? [TrackerCoreData]
            let trackers: [Tracker]? = $0.objects?.reduce(
                into: []
            ) { (result, data) in
                if
                    let trackerCoreData = data as? TrackerCoreData,
                    let id = trackerCoreData.id,
                    let name = trackerCoreData.name,
                    let colorString = trackerCoreData.color,
                    let color = UIColor(hexaDecimalString: colorString),
                    let emoji = trackerCoreData.emoji?.first,
                    let typeString = trackerCoreData.type
                {
                    let type = TrackerType(from: typeString)
                    let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, type: type)
                    result.append(tracker)
                }
            }
            return TrackerCategory(title: title, trackers: trackers ?? [])
        }
        
        return trackerCategories
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext?
    //private let trackerCategoryStore = TrackerCategoryStore()
    
    /*
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>? = {
        guard let context else { return nil }
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(
            entityName: String(describing: TrackerCoreData.self)
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
     */
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
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
    
    func setFetchedResultsController(for date: Date) {
        guard let context else { return }
        
        var dayNumber = Calendar.current.component(.weekday, from: date)
        dayNumber = dayNumber - 1 < 1 ? 7 : dayNumber - 1
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(
            entityName: String(describing: TrackerCoreData.self)
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[n] %@",
            #keyPath(TrackerCoreData.type),
            "\(dayNumber)"
        )
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        let trackerCoreData = try createTracker(from: tracker)
        guard let categoryCoreData = try? getCoreData(for: category) else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
        categoryCoreData.addToTrackers(trackerCoreData)
        try context.save()
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        let trackerCoreData = try createTracker(from: tracker)
        category.addToTrackers(trackerCoreData)
        try context.save()
    }

    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color.toHexString()
        trackerCoreData.emoji = String(tracker.emoji)
        trackerCoreData.type = tracker.type.toString()
    }
    
    // MARK: - Private Methods
    
    private func createTracker(from tracker: Tracker) throws -> TrackerCoreData {
        guard let context else {
            throw TrackerStoreError.couldNotGetContext
        }
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        return trackerCoreData
    }
    
    private func getCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData? {
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
            category.title
        )
        let category = try context.fetch(request).first
        
        return category
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerStoreUpdate(
                insertedIndexes: insertedIndexes
            )
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
