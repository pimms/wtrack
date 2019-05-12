//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutRepository {

    // MARK: - Internal properties

    var totalKilometersThisYear: Float {
        var distance: Double = 0.0

        workouts.forEach { workout in
            distance += (workout.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000.0
        }

        return Float(distance)
    }

    // MARK: - Private properties

    private let healthStore: HKHealthStore
    private var workouts: [HKWorkout] = []

    // MARK: - Init

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // MARK: - Public methods

    func loadWorkouts(completion: @escaping () -> Void) {
        fetchWorkouts { [weak self] workouts in
            self?.workouts = workouts
            completion()
        }
    }


    // MARK: - Private methods

    private func fetchWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sorting = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sorting], resultsHandler: { query, samples, err in
            let samples = samples ?? []

            let cal = Calendar.current
            let currentYear = cal.component(.year, from: Date())

            let filtered = samples.compactMap { $0 as? HKWorkout }
                                  .filter { cal.component(.year, from: $0.endDate) == currentYear }

            print("[WorkoutRepository] Loaded \(filtered.count) workouts")
            completion(filtered)
        })

        healthStore.execute(query)
    }
}
