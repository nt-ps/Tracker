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
        let parametersStackView = UIStackView(arrangedSubviews: [nameTextField, parametersTableView])
        parametersStackView.axis = .vertical
        parametersStackView.spacing = 24.0 // TODO: Вычислять относительно базовой единицы.
        parametersStackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0 // TODO: Вычислять относительно базовой единицы.
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    } ()
    
    private lazy var cancelButton: OutlineButton = {
        let cancelButton = OutlineButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(self.didTapCancelButton),
            for: .touchUpInside
        )
        return cancelButton
    } ()
    
    private lazy var createButton: SolidButton = {
        let createButton = SolidButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.addTarget(
            self,
            action: #selector(self.didTapCreateButton),
            for: .touchUpInside
        )
        createButton.isEnabled = false
        return createButton
    } ()
    
    // MARK: - Internal Properties
    
    weak var trackersNavigator: TrackersNavigatorItemProtocol?
    
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
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewTitle
        navigationItem.setHidesBackButton(true, animated: true)

        scrollView.addSubview(parametersStackView)
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        setConstraints()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapCancelButton() {
        // navigationController?.popViewController(animated: true)
        dismiss(animated: true) { }
    }
    
    @objc
    private func didTapCreateButton() {
        let tracker = Tracker(
            name: trackerName ?? "Без названия",
            type: trackerType ?? .event
        )
        TrackersDataMock.share.addTracker(tracker)
        dismiss(animated: true) { [weak self] in
            self?.trackersNavigator?.updateView()
        }
    }
    
    // MARK: - UI Updates
    
    private func updateCreateButton() {
        if
            let trackerName,
            !trackerName.isEmpty
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
            parametersStackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 16
            ),
            parametersStackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -16
            ),
            parametersStackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -32
            ),
            
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
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension TrackerEditorViewController: TrackerEditorViewControllerProtocol {
    func updateSchedule(from newValues: [WeekDay]) {
        switch trackerType {
        case .habit:
            let newSchedule = Schedule(days: newValues)
            self.trackerType = .habit(newSchedule)
            break
        default:
            break
        }
    }
}
