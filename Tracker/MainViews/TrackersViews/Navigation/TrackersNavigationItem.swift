import UIKit

final class TrackersNavigationItem: UIViewController {
    
    // MARK: - Views
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: addButtonIconResource),
            style: .plain,
            target: self,
            action: #selector(self.didTapAddButton)
        )
        addBarButtonItem.tintColor = .AppColors.black
        return addBarButtonItem
    } ()
    
    private lazy var dateBarButtonItem: UIBarButtonItem = {
        let dateBarButtonItem = UIBarButtonItem(customView: datePicker)
        return dateBarButtonItem
    } ()
    
    // Пока оставил в стандартном виде,
    // поскольку не нашел решения, как можно изменить формат даты
    // на кнопке. Пишут, что он сложно настраивается.
    // Предлагают "перекрыть" лэйблом, но как это сделать
    // так и не понял.
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = selectedDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return datePicker
    } ()
    
    private lazy var collectionView: TrackersCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = TrackersCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.navigationItem = self
        return collectionView
    } ()
    
    private lazy var stubView: StubView = {
        let stubView = StubView()
        stubView.labelText = stubLabelText
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    // MARK: - UI Properties
    
    private let stubLabelText = NSLocalizedString(
        "trackersView.stubText",
        comment: "Display text when list is empty"
    )
    private let addButtonIconResource: ImageResource = .Icons.plus
    private let dateButtonSpace = 6.0
    
    // MARK: - Internal Properties
    
    private(set) var selectedDate: Date = Date()
    
    // MARK: - Private Properties

    private let trackerStore = TrackerStore()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerStore.delegate = self
        
        navigationItem.title = NSLocalizedString("trackersView.title", comment: "UI view title")
        
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.rightBarButtonItem = dateBarButtonItem
        
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        
        updateCollection()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapAddButton() {
        let trackerEditorNavigationController = TrackerEditorNavigationController()
        present(trackerEditorNavigationController, animated: true)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateCollection()
    }
    
    // MARK: - UI Updates
    
    func updateCollection() {
        trackerStore.setFetchRequest(for: selectedDate)
        let categories = trackerStore.trackersByCategory
        if categories.isEmpty {
            showStub()
        } else {
            showCollectionView(with: categories)
        }
    }
    
    private func showStub() {
        collectionView.willMove(toSuperview: nil)
        collectionView.removeFromSuperview()
        
        view.addSubview(stubView)

        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showCollectionView(with categories: [TrackerCategory]) {
        stubView.willMove(toSuperview: nil)
        stubView.removeFromSuperview()
        
        collectionView.categories = categories
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.reloadData()
    }
}

extension TrackersNavigationItem: TrackerStoreDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        let oldCategories = collectionView.categories
        let newCategories = trackerStore.trackersByCategory
        
        guard !newCategories.isEmpty else {
            showStub()
            return
        }
        
        guard !oldCategories.isEmpty else {
            showCollectionView(with: newCategories)
            return
        }
        
        collectionView.categories = newCategories
        
        if !update.deletedIndexes.isEmpty {
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: update.deletedIndexes)
                for i in 0...oldCategories.count - 1 {
                    if !newCategories.contains(where: { oldCategories[i].title == $0.title }) {
                        collectionView.deleteSections(IndexSet(integer: i))
                    }
                }
            }
        }
        
        if !update.insertedIndexes.isEmpty {
            collectionView.performBatchUpdates {
                for i in 0...newCategories.count - 1 {
                    if !oldCategories.contains(where: { $0.title == newCategories[i].title }) {
                        collectionView.insertSections(IndexSet(integer: i))
                    }
                }
                collectionView.insertItems(at: update.insertedIndexes)
            }
        }
        
        if !update.updatedIndexes.isEmpty {
            collectionView.performBatchUpdates {
                let updateSectionsIndexes: Set<Int> = update.updatedIndexes.reduce(
                    into: []
                ) { (result, indexPath) in
                    result.insert(indexPath.section)
                }
                updateSectionsIndexes.forEach {
                    collectionView.reloadSections(IndexSet(integer: $0))
                }
                collectionView.reloadItems(at: update.insertedIndexes)
            }
        }
        
    }
}
