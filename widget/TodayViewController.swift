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
        let height: CGFloat = (activeDisplayMode == .compact ? 71.5 : 71.5*2+16) + 32
        // preferredContentSize = CGSize(width: maxSize.width, height: height)

        updateViews()
    }

    private func updateViews() {
        guard let workoutRepository = workoutRepository else { return }

        let progressCalculator = ProgressCalculator(goalRepository: goalRepository, workoutRepository: workoutRepository)


        var progressViews: [UIView] = [
            WeeklyProgress(viewModel: progressCalculator.weeklyProgress())
        ]

        if extensionContext?.widgetActiveDisplayMode == .some(.expanded) {
            progressViews.append(YearlyProgress(progress: progressCalculator.yearlyProgress()))
        }

        addViews(progressViews)
    }

    private func addViews(_ views: [UIView]) {
        guard let contentView = contentView else { return }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        var topAnchor: NSLayoutYAxisAnchor = contentView.topAnchor

        for v in views {
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
                v.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
                v.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            ])

            topAnchor = v.bottomAnchor
        }

        NSLayoutConstraint.activate([
            views[views.count - 1].bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }
    
}
