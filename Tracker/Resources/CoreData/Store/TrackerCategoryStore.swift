import CoreData
import UIKit

final class TrackerCategoryStore {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext?
    //private let trackerStore = TrackerStore()
    
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
    
    func addCategory(_ сategory: TrackerCategory) throws {
        if (try? getCoreData(for: сategory)) != nil {
            throw TrackerCategoryStoreError.categoryAlreadyExists
        }
        
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        try updateExistingTrackerCategory(trackerCategoryCoreData, with: сategory)
        try context.save()
    }

    func updateExistingTrackerCategory(
        _ trackerCategoryCoreData: TrackerCategoryCoreData,
        with trackerCategory: TrackerCategory
    ) throws {
        trackerCategoryCoreData.title = trackerCategory.title
        /*
        trackerCategoryCoreData.trackers = []
        try trackerCategory.trackers.forEach {
            try trackerStore.addTracker($0, to: trackerCategoryCoreData)
        }
         */
    }
    
    func addTracker(_ trackerCoreData: TrackerCoreData, to category: TrackerCategory) throws {
        guard let categoryCoreData = try? getCoreData(for: category) else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
        addTracker(trackerCoreData, to: categoryCoreData)
    }
    
    func addTracker(_ trackerCoreData: TrackerCoreData, to category: TrackerCategoryCoreData) {
        category.addToTrackers(trackerCoreData)
    }
    
    func getAll() throws -> [TrackerCategory]? {
        guard let context else {
            throw TrackerCategoryStoreError.couldNotGetContext
        }
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(
            entityName: String(describing: TrackerCategoryCoreData.self)
        )
        request.returnsObjectsAsFaults = false
        let categories = try context.fetch(request)
        
        return categories.reduce(
            into: []
        ) { (result, categoryCoreData) in
            if
                let title = categoryCoreData.title,
                let trackers = categoryCoreData.trackers
            {
                let filteredTrackers: [Tracker] = trackers.reduce(
                    into: []
                ) { (result, trackerCoreData) in
                    if
                        let trackerData = trackerCoreData as? TrackerCoreData
                    {
                        guard
                            let id = trackerData.id,
                            let name = trackerData.name,
                            let color = trackerData.color as? UIColor,
                            let emoji = trackerData.emoji?.first,
                            let typeString = trackerData.type
                        else { return }
                        
                        let type = TrackerType(from: typeString)
                        let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, type: type)
                        result.append(tracker)
                    }
                }
                
                if !filteredTrackers.isEmpty {
                    let category = TrackerCategory(
                        title: title,
                        trackers: filteredTrackers
                    )
                    result.append(category)
                }
            }
        }
    }
    
    // TODO: В будущем реализовать.
    // Пока не понятно, как провести фильтрацию внутреннего списка
    // трекеров (это раз) по дню недели (это два).
    // func getCategories(by date: Date) throws -> [TrackerCategory] { }
    
    // MARK: - Private Methods
    
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
