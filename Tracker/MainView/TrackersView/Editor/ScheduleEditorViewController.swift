import UIKit

final class ScheduleEditorViewController: UIViewController {
    
    // MARK: - UI Views
    
    private lazy var parametersTableView: ParametersTableView = {
        let parametersTableView = ParametersTableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        var parameters = [
            mondaySwitch, tuesdaySwitch, wednesdaySwitch,
            thursdaySwitch, fridaySwitch, saturdaySwitch, sundaySwitch
        ]
        parametersTableView.updateParameters(parameters)
        return parametersTableView
    } ()
    
    private lazy var mondaySwitch: SwitchTableViewCell = {
        let mondaySwitch = SwitchTableViewCell()
        mondaySwitch.title = "Понедельник"
        mondaySwitch.isOn = false
        return mondaySwitch
    } ()
    
    private lazy var tuesdaySwitch: SwitchTableViewCell = {
        let tuesdaySwitch = SwitchTableViewCell()
        tuesdaySwitch.title = "Вторник"
        tuesdaySwitch.isOn = false
        return tuesdaySwitch
    } ()
    
    private lazy var wednesdaySwitch: SwitchTableViewCell = {
        let wednesdaySwitch = SwitchTableViewCell()
        wednesdaySwitch.title = "Среда"
        wednesdaySwitch.isOn = false
        return wednesdaySwitch
    } ()
    
    private lazy var thursdaySwitch: SwitchTableViewCell = {
        let thursdaySwitch = SwitchTableViewCell()
        thursdaySwitch.title = "Четверг"
        thursdaySwitch.isOn = false
        return thursdaySwitch
    } ()
    
    private lazy var fridaySwitch: SwitchTableViewCell = {
        let fridaySwitch = SwitchTableViewCell()
        fridaySwitch.title = "Пятница"
        fridaySwitch.isOn = false
        return fridaySwitch
    } ()
    
    private lazy var saturdaySwitch: SwitchTableViewCell = {
        let saturdaySwitch = SwitchTableViewCell()
        saturdaySwitch.title = "Суббота"
        saturdaySwitch.isOn = false
        return saturdaySwitch
    } ()
    
    private lazy var sundaySwitch: SwitchTableViewCell = {
        let sundaySwitch = SwitchTableViewCell()
        sundaySwitch.title = "Воскресенье"
        sundaySwitch.isOn = false
        return sundaySwitch
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
