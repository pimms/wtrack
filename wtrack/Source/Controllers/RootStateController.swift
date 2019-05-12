//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit

class RootStateController: UIViewController {

    // MARK: - Private properties

    private let healthStore = HKHealthStore()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestHealthKitAccess()
    }

    // MARK: - Private methods

    private func requestHealthKitAccess() {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType())

        healthStore.requestAuthorization(toShare: nil, read: toRead, completion: { [weak self] success, err in
            if success, let healthStore = self?.healthStore {
                let workoutRepo = WorkoutRepository(healthStore: healthStore)
                let goalRepo = GoalRepository()

                workoutRepo.loadWorkouts {
                    DispatchQueue.main.async { [weak self] in
                        let mainVc = MainViewController(workoutRepository: workoutRepo, goalRepository: goalRepo)
                        self?.add(mainVc)
                    }
                }
            } else {
                print("HealthKit authorization failed: \(err)")
            }
        })
    }
}
