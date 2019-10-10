import UIKit
import NotificationCenter
import HealthKit
import wtrackKit

class TodayViewController: UIViewController, NCWidgetProviding {

    // MARK: - Private properties

    @IBOutlet private var contentView: UIView?
    private let goalRepository: GoalRepository = GoalRepository()
    private var workoutRepository: WorkoutRepository?

    // MARK: - Setup
        
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.translatesAutoresizingMaskIntoConstraints = false

        let healthStore = HKHealthStore()
        healthStore.requestAuthorization { [weak self] success, error in
            guard success else {
                print("Failed to request authorization. Error: \(String(describing: error))")
                return
            }

            self?.workoutRepository = WorkoutRepository(healthStore: healthStore)
        }

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }

    // MARK: - Updating
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        guard let workoutRepository = workoutRepository else {
            completionHandler(.failed)
            return
        }

        workoutRepository.loadWorkouts { [weak self] in
            DispatchQueue.main.async {
                self?.updateViews()
                completionHandler(.newData)
            }
        }
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        updateViews()
    }

    private func updateViews() {
        guard let workoutRepository = workoutRepository else { return }

        let progressCalculator = ProgressCalculator(goalRepository: goalRepository, workoutRepository: workoutRepository)
        var progressViews: [UIView] = [ WeeklyProgress(viewModel: progressCalculator.weeklyProgress()) ]

        if extensionContext?.widgetActiveDisplayMode == .some(.expanded) {
            progressViews.append(YearlyProgress(progress: progressCalculator.yearlyProgress()))
        }

        addViews(progressViews)
    }

    private func addViews(_ views: [UIView]) {
        guard let contentView = contentView else { return }
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = .mediumSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .mediumSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.mediumSpacing),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
