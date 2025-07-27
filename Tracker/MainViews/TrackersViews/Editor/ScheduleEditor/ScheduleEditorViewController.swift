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
        parametersTableView.updateParameters(viewModel?.days)
        return parametersTableView
    } ()
    
    private lazy var doneButton: SolidButton = {
        let doneButton = SolidButton()
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(
            self,
            action: #selector(didTapDoneButton),
            for: .touchUpInside
        )
        return doneButton
    } ()
    
    // MARK: - View Model
    
    private var viewModel: ScheduleEditorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Расписание"
        navigationItem.setHidesBackButton(true, animated: true)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        view.addSubview(doneButton)
        setConstraints()
    }
    
    // MARK: - View Model Methods
    
    func setViewModel(_ viewModel: ScheduleEditorViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapDoneButton() {
        viewModel?.saveSchedule()
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
