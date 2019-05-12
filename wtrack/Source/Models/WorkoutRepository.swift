//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutRepository {

    // MARK: - Private properties

    private let healthStore: HKHealthStore

    // MARK: - Init

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // MARK: - Public methods

    func fetchAllWorkouts() {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sorting = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sorting], resultsHandler: { query, samples, err in
            if let samples = samples {
                print("SAMPLES! :D \(samples.count) of them.")
                for sample in samples {
                    print(" - Workout: \(sample)")
                }
            }
        })

        healthStore.execute(query)
    }
}
