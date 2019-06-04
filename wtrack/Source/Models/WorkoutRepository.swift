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

    var totalKilometersThisWeek: Float {
        var distance: Double = 0.0

        let weekStart = Date.today().previous(.monday, considerToday: true)
        workouts.filter { $0.endDate >= weekStart }
                .map{ ($0.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000.0 }
                .forEach { distance += $0 }

        return Float(distance)
    }

    var workoutLengthsThisWeek: [Float] {
        var list = [Float]()

        let weekStart = Date.today().previous(.monday, considerToday: true)
        workouts
            .filter { $0.endDate >= weekStart }
            .map{ Float(($0.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000.0) }
            .forEach { list.append($0) }

        return list
    }

    var weeklyDistanceThisYear: [(Int, Float)] {
        var dict = Dictionary(grouping: workouts) {
            Calendar.current.component(.weekOfYear, from: $0.endDate)
        }.mapValues { (weekGroup: [HKWorkout]) -> Float in
            weekGroup.reduce(0, { (result, workout) -> Float in
                let v = result + Float(workout.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000.0
                return Float(v)
            })
        }

        // Ensure all weeks up until the current are present in the map
        let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
        for i in 1...currentWeek {
            if !dict.keys.contains(where: { $0 == i }) {
                dict[i] = 0
            }
        }

        // Sort it & ship it
        return dict.sorted { t1, t2 -> Bool in
            t1.key < t2.key
        }
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
