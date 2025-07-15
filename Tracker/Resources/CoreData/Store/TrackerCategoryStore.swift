import CoreData
import UIKit

final class TrackerCategoryStore {
    
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
    
    func addCategory(_ title: String) throws {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        if (try? getCategoryCoreData(title)) != nil {
            throw TrackerCategoryStoreError.categoryAlreadyExists
        }
        
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        try updateExistingCategory(trackerCategoryCoreData, with: title)
        try context.save()
    }

    func updateExistingCategory(
        _ trackerCategoryCoreData: TrackerCategoryCoreData,
        with title: String
    ) throws {
        trackerCategoryCoreData.title = title
        trackerCategoryCoreData.trackers = []
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
