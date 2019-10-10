//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit
import wtrackKit

class RootStateController: UIViewController {

    // MARK: - Private properties

    private let healthStore = HKHealthStore()
    private var workoutRepository: WorkoutRepository?
    private var mainViewController: MainViewController?
    private var hasEnteredBackground = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestHealthKitAccess()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    private func requestHealthKitAccess() {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType())

        healthStore.requestAuthorization(toShare: nil, read: toRead, completion: { [weak self] success, err in
            if success, let healthStore = self?.healthStore {
                let workoutRepo = WorkoutRepository(healthStore: healthStore)
                self?.workoutRepository = workoutRepo

                let goalRepo = GoalRepository()

                workoutRepo.loadWorkouts {
                    DispatchQueue.main.async { [weak self] in
                        let mainVc = MainViewController(workoutRepository: workoutRepo, goalRepository: goalRepo)
                        self?.mainViewController = mainVc
                        self?.add(mainVc)
                    }
                }
            } else {
                print("HealthKit authorization failed: \(String(describing: err))")
            }
        })
    }

    @objc private func applicationDidBecomeActive() {
        if hasEnteredBackground {
            print("[RootStateController] Application did become active")
            self.workoutRepository?.loadWorkouts { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.mainViewController?.reloadWorkoutData()
                }
            }
        }
    }

    @objc private func applicationWillResignActive() {
        hasEnteredBackground = true
    }
}
