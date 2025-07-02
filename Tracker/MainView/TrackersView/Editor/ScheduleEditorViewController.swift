import UIKit

final class ScheduleEditorViewController: UIViewController, ScheduleEditorViewControllerProtocol {
    
    // MARK: - UI Views
    
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
    
    // MARK: - Schedule Editor View Controller Protocol Properties
    
    weak var trackerEditorView: TrackerEditorViewControllerProtocol?
    
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
        
        view.addSubview(parametersTableView)
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
            parametersTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            parametersTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            parametersTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            parametersTableView.bottomAnchor.constraint(
                lessThanOrEqualTo: doneButton.topAnchor
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
