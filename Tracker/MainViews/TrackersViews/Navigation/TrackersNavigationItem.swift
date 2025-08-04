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
        collectionView.contentInset.bottom = filtersButtonHeight + filtersButtonXPadding * 2
        return collectionView
    } ()
    
    private lazy var stubView: StubView = {
        let stubView = StubView()
        stubView.labelText = stubLabelText
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    private lazy var filtersButton: UIButton = {
        let filtersButton = UIButton()
        let title = NSLocalizedString(
            "trackersView.filters",
            comment: "Filter button title"
        )
        filtersButton.setTitle(title, for: .normal)
        filtersButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filtersButton.setTitleColor(.AppColors.white, for: .normal)
        filtersButton.backgroundColor = .AppColors.blue
        filtersButton.layer.masksToBounds = true
        filtersButton.layer.cornerRadius = 16
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.addTarget(
            self,
            action: #selector(didFiltersButton),
            for: .touchUpInside
        )
        return filtersButton
    } ()
    
    // MARK: - UI Properties
    
    private let stubLabelText = NSLocalizedString(
        "trackersView.stubText",
        comment: "Display text when list is empty"
    )
    private let addButtonIconResource: ImageResource = .Icons.plus
    private let dateButtonSpace = 6.0
    
    private let filtersButtonHeight = 50.0
    private let filtersButtonXPadding = 20.0
    private let filtersButtonYSpacing = 16.0
    
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
        
        view.addSubview(collectionView)
        view.addSubview(stubView)
        view.addSubview(filtersButton)
        setConstraint()
        
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
    
    @objc
    private func didFiltersButton() {
        let filtersNavigationController = FiltersNavigationController()
        present(filtersNavigationController, animated: true)
    }
    
    // MARK: - Internal Methods
    
    func deleteTracker(_ tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString(
                "trackersView.deleteAlertMessage",
                comment: "Delete alert message"
            ),
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("deleteButtonTitle", comment: "Delete button title"),
            style: .destructive
        ) { [weak self] _ in
            try? self?.trackerStore.deleteTracker(tracker)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancelButtonTitle", comment: "Cancel button title"),
            style: .cancel
        )
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func editTracker(_ tracker: Tracker, category: String, recordsNum: Int) {
        let trackerEditorNavigationController = TrackerEditorNavigationController()
        trackerEditorNavigationController.trackerBuilder = TrackerBuilder(
            for: tracker, category: category, recordsNum: recordsNum
        )
        present(trackerEditorNavigationController, animated: true)
    }
    
    // MARK: - UI Updates
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filtersButton.heightAnchor.constraint(equalToConstant: filtersButtonHeight),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -filtersButtonYSpacing
            )
        ])
        
        if let filtersButtonLabel = filtersButton.titleLabel {
            filtersButton.widthAnchor.constraint(
                equalTo: filtersButtonLabel.widthAnchor,
                constant: filtersButtonXPadding * 2
            ).isActive = true
        }
    }
    
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
        collectionView.isHidden = true
        stubView.isHidden = false
        stubView.bringSubviewToFront(collectionView)
    }
    
    private func showCollectionView(with categories: [TrackerCategory]) {
        collectionView.isHidden = false
        stubView.isHidden = true
        collectionView.bringSubviewToFront(stubView)
        
        collectionView.categories = categories
        collectionView.reloadData()
    }
}

extension TrackersNavigationItem: TrackerStoreDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        let oldCategories = collectionView.categories
        let newCategories = trackerStore.trackersByCategory
        
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
                    let header = collectionView.supplementaryView(
                        forElementKind: UICollectionView.elementKindSectionHeader,
                        at: IndexPath(item: 0, section: $0)
                    ) as? HeaderView
                    header?.title = newCategories[$0].title
                }
                collectionView.reloadItems(at: update.updatedIndexes)
            }
        }
        
        // Не комментируйте это, пожалуйста, никак...
        // Мне сложно объяснить, что я тут понаписал, но это работает для всех случаев перемещения.
        // Когда удаляются секции, когда создаются новые, когда секции не трогаются.
        // И ячейки обновляются при перемещении. Короче больше никак, иначе ругается.
        if !update.movedIndexes.isEmpty {
            collectionView.performBatchUpdates {
                for i in 0...oldCategories.count - 1 {
                    if !newCategories.contains(where: { oldCategories[i].title == $0.title }) {
                        collectionView.deleteSections(IndexSet(integer: i))
                    }
                }
                
                for i in 0...newCategories.count - 1 {
                    if !oldCategories.contains(where: { $0.title == newCategories[i].title }) {
                        collectionView.insertSections(IndexSet(integer: i))
                    }
                }
                
                update.movedIndexes.forEach { indexes in
                    if let oldSectionByNewData = newCategories.firstIndex(
                        where: {$0.title == oldCategories[indexes.0.section].title}
                    ) {
                        collectionView.moveItem(
                            at: IndexPath(item: indexes.0.item, section: oldSectionByNewData),
                            to: indexes.1
                        )
                    } else {
                        collectionView.insertItems(at: [indexes.1])
                    }
                }
            }
            
            collectionView.performBatchUpdates {
                collectionView.reloadItems(at: update.movedIndexes.map { $0.1 })
            }
        }
        
        if newCategories.isEmpty {
            showStub()
        }
    }
}
