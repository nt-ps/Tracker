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
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [doneButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8.0
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    } ()
    
    private lazy var doneButton: SolidButton = {
        let doneButton = SolidButton()
        let buttonTitle = NSLocalizedString("doneButtonTitle", comment: "Done button title")
        doneButton.setTitle(buttonTitle, for: .normal)
        doneButton.addTarget(
            self,
            action: #selector(didTapDoneButton),
            for: .touchUpInside
        )
        return doneButton
    } ()
    
    // MARK: - UI Properties
    
    private let stackViewXSpacing = 16.0
    private let stackViewYSpacing = 24.0
    
    private let buttonsXSpacing = 20.0
    private let buttonsTopSpacing = 8.0
    private let buttonsBottomSpacing = ScreenType.shared.isWithIsland ? 16.0 : 24.0
    private let buttonsHeight = 68.0
    
    
    // MARK: - View Model
    
    private var viewModel: ScheduleEditorViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString("scheduleEditor.title", comment: "UI view title")
        navigationItem.setHidesBackButton(true, animated: true)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        view.addSubview(buttonsStackView)
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
                constant: stackViewYSpacing
            ),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -stackViewYSpacing
            ),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: stackViewXSpacing
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -stackViewXSpacing
            ),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -stackViewXSpacing * 2
            ),
             
            buttonsStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: buttonsXSpacing
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -buttonsXSpacing
            ),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -buttonsBottomSpacing
            ),
            buttonsStackView.heightAnchor.constraint(
                equalToConstant: buttonsHeight
            ),
            
            doneButton.topAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: buttonsTopSpacing
            )
        ])
    }
}
