import UIKit

final class ScheduleEditorViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [parametersTableView])
        stackView.axis = .vertical
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
     
    private lazy var parametersTableView: ParametersTableView = {
        let parametersTableView = ParametersTableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters = daySwitches.map { $0.value }
        parametersTableView.updateParameters(parameters)
        return parametersTableView
    } ()
    
    private lazy var daySwitches: [Dictionary<WeekDay, SwitchTableViewCell>.Element] = {
        var switches: [WeekDay: SwitchTableViewCell] = [:]
        WeekDay.allCases.forEach {
            let switchCell = SwitchTableViewCell()
            switchCell.title = $0.getName()
            switchCell.isOn = false
            switches[$0] = switchCell
        }
        return switches.sorted { $0.key.rawValue < $1.key.rawValue }
    } ()
    
    private lazy var doneButton: SolidButton = {
        let createButton = SolidButton()
        createButton.setTitle("Готово", for: .normal)
        createButton.addTarget(
            self,
            action: #selector(self.didTapDoneButton),
            for: .touchUpInside
        )
        return createButton
    } ()
    
    // MARK: - Internal Properties
    
    weak var trackerEditorView: TrackerEditorViewController?
    
    var days: [WeekDay] {
        get {
            Array(
                daySwitches
                    .filter{ $0.value.isOn }
                    .map{ $0.key }
            )
        }
        set {
            daySwitches.forEach {
                $0.value.isOn = newValue.contains($0.key)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Расписание"
        navigationItem.setHidesBackButton(true, animated: true)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        view.addSubview(doneButton)
        setConstraints()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapDoneButton() {
        trackerEditorView?.updateSchedule(from: days)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Updates

    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 24
            ),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -24
            ),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -16
            ),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -32
            ),
             
            doneButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            doneButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            doneButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: ScreenType.shared.isWithIsland ? 0 : -24
            ),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
