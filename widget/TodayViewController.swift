import UIKit
import NotificationCenter
import HealthKit
import wtrackKit

class TodayViewController: UIViewController, NCWidgetProviding {

    // MARK: - Private properties

    @IBOutlet private var weeklyProgressPanel: TodayPanel?
    @IBOutlet private var yearlyProgressPanel: TodayPanel?

    private let goalRepository: GoalRepository = GoalRepository()
    private var workoutRepository: WorkoutRepository?

    // MARK: - Setup
        
    override func viewDidLoad() {
        super.viewDidLoad()

        weeklyProgressPanel?.setTitleText("Weekly Progress")
        yearlyProgressPanel?.setTitleText("Yearly Progress")

        let healthStore = HKHealthStore()
        healthStore.requestAuthorization { [weak self] success, error in
            guard success else {
                print("Failed to request authorization. Error: \(String(describing: error))")
                return
            }

            self?.workoutRepository = WorkoutRepository(healthStore: healthStore)
        }

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        updateYearlyVisibility()
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    private func updateViews() {
        guard let workoutRepository = workoutRepository else { return }

        let progressCalculator = ProgressCalculator(goalRepository: goalRepository, workoutRepository: workoutRepository)
        let weeklyModel = progressCalculator.weeklyProgress()
        let yearlyModel = progressCalculator.yearlyProgress()

        weeklyProgressPanel?.setProgress(progressValues: weeklyModel.weeklyDistances, goal: weeklyModel.goalDistance)
        yearlyProgressPanel?.setProgress(progressValues: [yearlyModel.currentValue], goal: yearlyModel.goalValue)

        updateYearlyVisibility()
    }

    private func updateYearlyVisibility() {
        let expanded = extensionContext?.widgetActiveDisplayMode == .expanded
        yearlyProgressPanel?.isHidden = !expanded
    }
}
