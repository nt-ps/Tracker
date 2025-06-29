import UIKit

final class TrackersViewController: UIViewController {
    
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
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return datePicker
    } ()
     
    
    // MARK: - UI Properties
    
    private let addButtonIconName = "Icons/Plus"
    private let dateButtonSpace = 6.0
    
    // MARK: - Private Properties
    
    private var selectedDate: Date?
    
    // MARK: - Static Properties
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    } ()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        // showStub()
        showCollectionView()
        
        setConstraints()
        
        selectedDate = Date()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapAddButton() { }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    // MARK: - UI Updates
    
    private func setNavigationItem() {
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.rightBarButtonItem = dateBarButtonItem
        
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func showStub() {
        let trackersStubView = TrackersStubView()
        
        view.addSubview(trackersStubView)
        
        trackersStubView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackersStubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersStubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = TrackersCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setConstraints() { }
}
