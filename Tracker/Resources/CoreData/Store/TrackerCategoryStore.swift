import CoreData
import UIKit

final class TrackerCategoryStore: NSObject, CategoriesSourceProtocol {
    
    // MARK: - Internal Properties
    
    weak var delegate: CategoriesSourceDelegate?
    
    var categories: [String] {
        guard let categories = fetchedResultsController?.fetchedObjects else { return [] }
    
        let trackerCategories: [String] = categories.reduce(
            into: []
        ) { (result, data) in
            if let title = data.title {
                result.append(title)
            }
        }
        
        return trackerCategories
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext?
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>? = {
        guard let context else { return nil }
        
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(
            entityName: String(describing: TrackerCategoryCoreData.self)
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
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
    
    func addCategory(_ title: String) throws {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        if (try? getCategoryCoreData(title)) != nil {
            throw TrackerCategoryStoreError.categoryAlreadyExists
        }
        
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        trackerCategoryCoreData.trackers = []
        try context.save()
    }
    
    func updateCategory(_ oldTitle: String, newTitle: String) throws {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        guard let trackerCategoryCoreData = try? getCategoryCoreData(oldTitle) else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
    
        trackerCategoryCoreData.title = newTitle
        
        // Прописал так, чтобы приходило уведомление об обновлении в TrackerStoreDelegate.
        // Иначе коллекция никак не узнает об изменении заголовка.
        let trackers = trackerCategoryCoreData.trackers?.array as? [TrackerCoreData]
        trackers?.forEach { $0.category = trackerCategoryCoreData }
        try context.save()
    }
    
    func deleteCategory(_ title: String) throws {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        guard let trackerCategoryCoreData = try getCategoryCoreData(title) else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
        
        context.delete(trackerCategoryCoreData)
        
        let trackers = trackerCategoryCoreData.trackers?.array as? [TrackerCoreData]
        trackers?.forEach { tracker in
            let records = tracker.records?.allObjects as? [TrackerRecordCoreData]
            records?.forEach { context.delete($0) }
            context.delete(tracker)
        }
        
        try context.save()
    }
    
    // MARK: - Private Methods
    
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
        let category = try context.fetch(request).first
        
        return category
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            CategoriesSourceUpdate(insertedIndexes: insertedIndexes)
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
