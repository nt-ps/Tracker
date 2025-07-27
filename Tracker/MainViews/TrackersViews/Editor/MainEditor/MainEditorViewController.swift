import UIKit

final class MainEditorViewController: UIViewController {
    
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
        parametersStackView.spacing = stackItemYSpacing
        parametersStackView.translatesAutoresizingMaskIntoConstraints = false
        parametersStackView.isLayoutMarginsRelativeArrangement = true
        return parametersStackView
    } ()
    
    private lazy var nameTextField: OneLineTextField = {
        let nameTextField = OneLineTextField()
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.editingAction = nameDidChange
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    } ()
    
    private lazy var parametersTableView: ParametersTableView = {
        let parametersTableView = ParametersTableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters = [categoryButton]
        if let viewModel, viewModel.isScheduleAvailable {
            parameters.append(scheduleButton)
        }
        parametersTableView.updateParameters(parameters)
        return parametersTableView
    } ()
    
    // TODO: При выборе категории кнопка сохранения почему-то не всегда делается активной.
    private lazy var categoryButton: ButtonTableViewCell = {
        let categoryButton = ButtonTableViewCell()
        categoryButton.title = "Категория"
        categoryButton.tapAction = showCategories
        return categoryButton
    } ()
    
    private lazy var scheduleButton: ButtonTableViewCell = {
        let scheduleButton = ButtonTableViewCell()
        scheduleButton.title = "Расписание"
        scheduleButton.tapAction = showScheduleEditor
        return scheduleButton
    } ()
    
    private lazy var emojiCollectionView: SelectorCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = SelectorCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        emojiCollectionView.title = "Emoji"
        emojiCollectionView.addValues(viewModel?.emojiValues)
        emojiCollectionView.selectionAction = emojiDidChange
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
        colorCollectionView.addValues(viewModel?.colorValues)
        colorCollectionView.selectionAction = colorDidChange
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
    
    // MARK: - UI Properties
    
    private let stackItemXSpacing = 16.0
    private let stackItemYSpacing = 24.0
    
    // MARK: - Internal Properties
    
    // TODO: Возможно не понадобится после перехода на MVVM.
    // weak var trackersNavigator: TrackersNavigationItem?
    
    // var viewTitle: String?
    
    // var trackerName: String? { nameTextField.text }
    
    /*
    var trackerCategory: String? {
        didSet {
            categoryButton.subtitle = trackerCategory
        }
    }
     */
    
    /*
    var trackerType: TrackerType? {
        didSet {
            if let trackerType {
                switch trackerType{
                case .habit(let schedule):
                    scheduleButton.subtitle = schedule.toString()
                    // updateCreateButton()
                    break
                default:
                    break
                }
            }
        }
    }
     */
    
    // var trackerEmoji: Character? { emojiCollectionView.selectedItem as? Character }
    // var trackerColor: UIColor? { colorCollectionView.selectedItem as? UIColor }
    
    // MARK: - View Model
    
    private var viewModel: MainEditorViewModel?
    
    // MARK: - Private Properties
    
    private let trackerStore = TrackerStore()
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = viewModel?.mainEditorTitle
        navigationItem.setHidesBackButton(true, animated: true)

        scrollView.addSubview(parametersStackView)
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        setConstraints()
        
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: MainEditorViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onTrackerCreationAllowedStateChange = { [weak self] isCreationAllowed in
            self?.setCreateButton(enabled: isCreationAllowed)
        }
        
        viewModel.onNameErrorStateChange = { [weak self] message in
            self?.setNameError(message)
        }
        
        viewModel.onCategorySelectionStateChange = { [weak self] category in
            self?.setCategory(category)
        }
        
        viewModel.onScheduleStateChange = { [weak self] schedule in
            self?.setSchedule(schedule)
        }
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true) { }
    }
    
    @objc
    private func didTapCreateButton() {
        /*
        // TODO: В будущем выводить алерт с ошибкой.
        guard let trackerCategory else { return }
        let tracker = Tracker(
            name: trackerName ?? "Без названия",
            color: trackerColor ?? .black,
            emoji: trackerEmoji ?? " ",
            type: trackerType ?? .event
        )
        try? trackerStore.addTracker(tracker, to: trackerCategory)
        dismiss(animated: true)
         */
        
        viewModel?.addTracker()
        dismiss(animated: true)
    }
    
    // MARK: - UI Updates
    
    private func setCreateButton(enabled: Bool) {
        createButton.isEnabled = enabled
    }
    
    private func nameDidChange() {
        viewModel?.didNameEnter(nameTextField.text)
    }
    
    private func setNameError(_ message: String?) {
        nameTextField.message = message
    }
    
    private func setCategory(_ category: String?) {
        categoryButton.subtitle = category
    }
    
    private func setSchedule(_ schedule: String?) {
        scheduleButton.subtitle = schedule
    }
    
    private func emojiDidChange() {
        let value = emojiCollectionView.selectedValue as? Character
        viewModel?.emojiDidChange(value)
    }
    
    private func colorDidChange() {
        let value = colorCollectionView.selectedValue as? UIColor
        viewModel?.colorDidChange(value)
    }
    
    private func showScheduleEditor() {
        guard let trackerEditorViewModel = viewModel?.trackerEditorViewModel else { return }
        
        let scheduleEditorViewController = ScheduleEditorViewController()
        
        let scheduleEditorViewModel = ScheduleEditorViewModel(from: trackerEditorViewModel)
        scheduleEditorViewController.setViewModel(scheduleEditorViewModel)
        
        // scheduleEditorViewController.trackerEditorView = self
        /*
        switch trackerType {
        case .habit(let schedule):
            scheduleEditorViewController.days = schedule.days
            break
        default:
            break
        }
         */
        navigationController?.pushViewController(scheduleEditorViewController, animated: true)
    }
    
    private func showCategories() {
        guard let trackerEditorViewModel = viewModel?.trackerEditorViewModel else { return }
        
        let categoriesViewController = CategoriesViewController()
        
        let trackerCategoryStore = TrackerCategoryStore()
        
        let categoriesViewModel = CategoriesViewModel(
            from: trackerEditorViewModel,
            with: trackerCategoryStore
        )
        categoriesViewController.setViewModel(categoriesViewModel)
        
        //categoriesViewController.trackerEditorView = self
        //categoriesViewController.selectedCategory = trackerCategory ?? nil
        navigationController?.pushViewController(categoriesViewController, animated: true)
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
                constant: stackItemYSpacing
            ),
            parametersStackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -stackItemYSpacing
            ),
            parametersStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: stackItemXSpacing
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -stackItemXSpacing
            ),
            
            parametersTableView.leadingAnchor.constraint(
                equalTo: parametersStackView.leadingAnchor,
                constant: stackItemXSpacing
            ),
            parametersTableView.trailingAnchor.constraint(
                equalTo: parametersStackView.trailingAnchor,
                constant: -stackItemXSpacing
            ),
            
            emojiCollectionView.topAnchor.constraint(
                equalTo: parametersTableView.bottomAnchor,
                constant: 20
            ),
            emojiCollectionView.leadingAnchor.constraint(
                equalTo: parametersTableView.leadingAnchor,
                constant: -stackItemXSpacing
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
                constant: stackItemXSpacing
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -stackItemXSpacing
            ),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: ScreenType.shared.isWithIsland ? 0 : -stackItemYSpacing
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
        /*
        switch trackerType {
        case .habit:
            let newSchedule = Schedule(days: newValues)
            trackerType = .habit(newSchedule)
            break
        default:
            break
        }
         */
    }
}
