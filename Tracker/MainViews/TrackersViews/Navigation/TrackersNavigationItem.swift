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
    
    private lazy var stubView: TrackersStubView = {
        let stubView = TrackersStubView()
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    // MARK: - UI Properties
    
    private let addButtonIconName = "Icons/Plus"
    private let dateButtonSpace = 6.0
    
    // MARK: - Internal Properties
    
    private(set) var selectedDate: Date = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let categories = filterCategories(
            TrackersMockData.share.data,
            by: selectedDate
        )
        
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
    
    // MARK: - Private Methods
    
    private func filterCategories(
        _ categories: [TrackerCategory],
        by date: Date
    ) -> [TrackerCategory] {
        let filteredCategories: [TrackerCategory] = categories.reduce(
            into: []
        ) { (result, category) in
            
            let filteredTrackers: [Tracker] = filterTrackers(
                category.trackers,
                by: date
            )
            
            if !filteredTrackers.isEmpty {
                let newCategory = TrackerCategory(
                    title: category.title,
                    trackers: filteredTrackers
                )
                result.append(newCategory)
            }
        }
        
        return filteredCategories
    }
    
    private func filterTrackers(
        _ trackers: [Tracker],
        by date: Date
    ) -> [Tracker] {
        var dayNumber = Calendar.current.component(.weekday, from: date)
        dayNumber = dayNumber - 1 < 1 ? 7 : dayNumber - 1
        
        let filteredTrackers: [Tracker] = trackers.reduce(
            into: []
        ) { (result, tracker) in
            switch tracker.type {
            case .event:
                result.append(tracker)
            case .habit(let schedule):
                if schedule.contains(dayNumber: dayNumber) {
                    result.append(tracker)
                }
            }
        }
        
        return filteredTrackers
    }
}
