import UIKit

final class TrackerEditorViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    } ()
    
    private lazy var parametersStackView: UIStackView = {
        let parametersStackView = UIStackView(
            arrangedSubviews: [
                nameTextField,
                parametersTableView,
                emojiCollectionView,
                colorCollectionView
            ]
        )
        parametersStackView.axis = .vertical
        parametersStackView.spacing = 24.0
        parametersStackView.translatesAutoresizingMaskIntoConstraints = false
        parametersStackView.isLayoutMarginsRelativeArrangement = true
        return parametersStackView
    } ()
    
    private lazy var nameTextField: OneLineTextField = {
        let nameTextField = OneLineTextField()
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.editingAction = updateCreateButton
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    } ()
    
    private lazy var parametersTableView: ParametersTableView = {
        let parametersTableView = ParametersTableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters = [categoryButton]
        switch trackerType {
        case .habit:
            parameters.append(scheduleButton)
        default:
            break
        }
        parametersTableView.updateParameters(parameters)
        return parametersTableView
    } ()
    
    private lazy var categoryButton: ButtonTableViewCell = {
        let categoryButton = ButtonTableViewCell()
        categoryButton.title = "Категория"
        return categoryButton
    } ()
    
    private lazy var scheduleButton: ButtonTableViewCell = {
        let scheduleButton = ButtonTableViewCell()
        scheduleButton.title = "Расписание"
        scheduleButton.tapAction = { [weak self] in
            self?.showScheduleEditor()
        }
        return scheduleButton
    } ()
    
    private lazy var emojiCollectionView: SelectorCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = SelectorCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        emojiCollectionView.title = "Emoji"
        emojiCollectionView.addValues(TrackerViewData.emoji)
        emojiCollectionView.selectAction = { [weak self] in
            self?.updateCreateButton()
        }
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    } ()
    
    private lazy var colorCollectionView: SelectorCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colorCollectionView = SelectorCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        colorCollectionView.title = "Цвет"
        colorCollectionView.addValues(TrackerViewData.colors)
        colorCollectionView.selectAction = { [weak self] in
            self?.updateCreateButton()
        }
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return colorCollectionView
    } ()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    } ()
    
    private lazy var cancelButton: OutlineButton = {
        let cancelButton = OutlineButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )
        return cancelButton
    } ()
    
    private lazy var createButton: SolidButton = {
        let createButton = SolidButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        createButton.isEnabled = false
        return createButton
    } ()
    
    // MARK: - Internal Properties
    
    weak var trackersNavigator: TrackersNavigationItem?
    
    var viewTitle: String?
    
    var trackerName: String? { nameTextField.text }
    
    var trackerType: TrackerType? {
        didSet {
            if let trackerType {
                switch trackerType{
                case .habit(let schedule):
                    scheduleButton.subtitle = schedule.toString()
                    updateCreateButton()
                    break
                default:
                    break
                }
            }
        }
    }
    
    var trackerEmoji: Character? { emojiCollectionView.selectedItem as? Character }
    var trackerColor: UIColor? { colorCollectionView.selectedItem as? UIColor }
    
    // MARK: - Private Properties
    
    private let trackerStore = TrackerStore()
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewTitle
        navigationItem.setHidesBackButton(true, animated: true)

        scrollView.addSubview(parametersStackView)
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        setConstraints()
        
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true) { }
    }
    
    @objc
    private func didTapCreateButton() {
        let tracker = Tracker(
            name: trackerName ?? "Без названия",
            color: trackerColor ?? .black,
            emoji: trackerEmoji ?? " ",
            type: trackerType ?? .event
        )
        // TODO: В будущем выводить алерт с ошибкой.
        try? trackerStore.addTracker(tracker, to: TrackersMockData.defaultCategoryTitle)
        dismiss(animated: true)
    }
    
    // MARK: - UI Updates
    
    private func updateCreateButton() {
        if
            let trackerName,
            !trackerName.isEmpty,
            trackerEmoji != nil,
            trackerColor != nil
        {
            switch trackerType{
            case .habit(let schedule):
                createButton.isEnabled = !schedule.days.isEmpty
                break
            default:
                createButton.isEnabled = true
                break
            }
        } else {
            createButton.isEnabled = false
        }
    }
    
    private func showScheduleEditor() {
        let scheduleEditorViewController = ScheduleEditorViewController()
        scheduleEditorViewController.trackerEditorView = self
        switch trackerType {
        case .habit(let schedule):
            scheduleEditorViewController.days = schedule.days
            break
        default:
            break
        }
        navigationController?.pushViewController(scheduleEditorViewController, animated: true)
    }

    private func setConstraints() {
        let emojiCollectionViewHeight = emojiCollectionView.estimatHeight(for: view.bounds)
        let colorCollectionViewHeight = colorCollectionView.estimatHeight(for: view.bounds)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            parametersStackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 24
            ),
            parametersStackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -24
            ),
            parametersStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: 16
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -16
            ),
            
            parametersTableView.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: 16
            ),
            parametersTableView.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -16
            ),
            
            emojiCollectionView.topAnchor.constraint(
                equalTo: parametersTableView.bottomAnchor,
                constant: 20
            ),
            emojiCollectionView.leadingAnchor.constraint(
                equalTo: parametersTableView.leadingAnchor,
                constant: -16
            ),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: emojiCollectionViewHeight),
            
            colorCollectionView.topAnchor.constraint(
                equalTo: emojiCollectionView.bottomAnchor
            ),
            colorCollectionView.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor
            ),
            colorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: colorCollectionViewHeight),
            
            buttonsStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: ScreenType.shared.isWithIsland ? 0 : -24
            ),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 68),
            
            cancelButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: 8
            ),
            
            createButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: 8
            )
        ])
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: view,
            action: #selector(view.endEditing)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Internal Methods
    
    func updateSchedule(from newValues: [WeekDay]) {
        switch trackerType {
        case .habit:
            let newSchedule = Schedule(days: newValues)
            trackerType = .habit(newSchedule)
            break
        default:
            break
        }
    }
}
