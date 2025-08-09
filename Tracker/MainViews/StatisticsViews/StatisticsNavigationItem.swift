import UIKit

final class StatisticsNavigationItem: UIViewController {
    
    // MARK: - Views

    private lazy var finishedNumberCounter: CounterView = {
        let counterView = CounterView()
        counterView.title = NSLocalizedString(
            "statisticsView.finishedNumberLabel",
            comment: "Finished number counter label"
        )
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    } ()
    
    private lazy var stubView: StubView = {
        let stubView = StubView()
        stubView.labelText = NSLocalizedString(
            "statisticsView.stubText",
            comment: "Display text when there is no data for statistics"
        )
        stubView.imageResource = .StubImages.emptyStatistics
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
    } ()
    
    // MARK: - UI Properties
    
    private let xPadding = 16.0
    
    // MARK: - Private Properties
    
    private let statisticsService = StatisticsService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("statisticsView.title", comment: "UI view title")
        
        view.addSubview(finishedNumberCounter)
        view.addSubview(stubView)
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if statisticsService.isDataValid {
            finishedNumberCounter.number = statisticsService.finishedNumber
            showData()
        } else {
            showStub()
        }
    }
    
    // MARK: - UI Updates
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            finishedNumberCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            finishedNumberCounter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            finishedNumberCounter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),
            
            finishedNumberCounter.heightAnchor.constraint(equalToConstant: 90),
            
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showStub() {
        finishedNumberCounter.isHidden = true
        stubView.isHidden = false
        stubView.bringSubviewToFront(finishedNumberCounter)
    }
    
    private func showData() {
        finishedNumberCounter.isHidden = false
        stubView.isHidden = true
        finishedNumberCounter.bringSubviewToFront(stubView)
    }
}
