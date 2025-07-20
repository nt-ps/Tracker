import UIKit

final class TrackersNavigationItem: UIViewController {
    
    // MARK: - Views
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(
            image: UIImage(named: addButtonIconName),
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
    
    private let stubLabelText = "Что будем отслеживать?"
    private let addButtonIconName = "Icons/Plus"
    private let dateButtonSpace = 6.0
    
    // MARK: - Internal Properties
    
    private(set) var selectedDate: Date = Date()
    
    // MARK: - Private Properties
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerStore.delegate = self
        
        navigationItem.title = "Трекеры"
        
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
        trackerEditorNavigationController.trackersNavigationItem = self
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

        // TODO: Определение индексов новых категорий.
        // Написано грубо, переписать.
        let newCategoriesIndeces: [Int] = newCategories.count > oldCategories.count ? newCategories.reduce(
            into: []
        ) { (result, data) in
            let title = data.title
            if !oldCategories.contains(where: { $0.title == title }) {
                guard let index = newCategories.firstIndex(where: { $0.title == title }) else { return }
                result.append(index)
            }
        } : []
        
        guard !newCategories.isEmpty else {
            showStub()
            return
        }
        
        guard collectionView.categories.isEmpty else {
            collectionView.categories = newCategories
            collectionView.performBatchUpdates {
                newCategoriesIndeces.forEach {
                    collectionView.insertSections(IndexSet(integer: $0))
                }
                //let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0.item, section: $0.section) }
                collectionView.insertItems(at: update.insertedIndexes)
            }
            return
        }

        showCollectionView(with: newCategories)
    }
}
