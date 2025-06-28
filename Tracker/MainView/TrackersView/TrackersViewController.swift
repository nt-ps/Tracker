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
        addBarButtonItem.tintColor = .YPColors.black
        return addBarButtonItem
    } ()
    
    private lazy var dateBarButtonItem: UIBarButtonItem = {
        let title = TrackersViewController.dateFormatter.string(from: Date())
        
        let dateButton = UIButton(type: .system)
        dateButton.setTitle(title, for: .normal)
        dateButton.tintColor = .YPColors.black
        dateButton.backgroundColor = .YPColors.gray
        dateButton.layer.masksToBounds = true
        dateButton.layer.cornerRadius = 8
        
        if let titleLabel = dateButton.titleLabel {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: dateButton.leadingAnchor,
                    constant: dateButtonSpace
                ),
                titleLabel.trailingAnchor.constraint(
                    equalTo: dateButton.trailingAnchor,
                    constant: -dateButtonSpace
                ),
                titleLabel.topAnchor.constraint(
                    equalTo: dateButton.topAnchor,
                    constant: dateButtonSpace
                ),
                titleLabel.bottomAnchor.constraint(
                    equalTo: dateButton.bottomAnchor,
                    constant: -dateButtonSpace
                ),
            ])
        }
        
        let dateBarButtonItem = UIBarButtonItem(customView: dateButton)
        return dateBarButtonItem
    } ()
    
    // MARK: - UI Properties
    
    private let addButtonIconName = "Icons/Add"
    private let dateButtonSpace = 6.0
    
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
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapAddButton() { }
    
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
        let collectionView = TrackersCollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
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
