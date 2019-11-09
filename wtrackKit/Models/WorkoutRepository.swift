//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation
import HealthKit

public class WorkoutRepository {

    // MARK: - Private properties

    private let healthStore: HKHealthStore
    private var workouts: [HKWorkout] = []

    private var workoutsThisYear: [HKWorkout] {
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())

        return workouts.filter { workout in
            cal.component(.year, from: workout.endDate) == currentYear
        }
    }

    // MARK: - Init

    public init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // MARK: - Public methods

    public func loadWorkouts(completion: @escaping () -> Void) {
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
            let samples = (samples ?? []).compactMap { $0 as? HKWorkout }
            print("[WorkoutRepository] Loaded \(samples.count) workouts")
            completion(samples)
        })

        healthStore.execute(query)
    }
}

// MARK: - Aggregated properties

extension WorkoutRepository {

    public var totalKilometers: Double {
        var distance: Double = 0.0

        workouts.forEach { workout in
            distance += workout.distanceInKilometers
        }

        return distance
    }

    public var totalKilometersThisYear: Double {
        var distance: Double = 0.0

        workoutsThisYear.forEach { workout in
            distance += workout.distanceInKilometers
        }

        return distance
    }

    public var totalKilometersThisWeek: Double {
        var distance: Double = 0.0

        let weekStart = Date.today().previous(.monday, considerToday: true)
        workouts.filter { $0.endDate >= weekStart }
                .map{ $0.distanceInKilometers }
                .forEach { distance += $0 }

        return distance
    }

    public var workoutLengthsThisWeek: [Double] {
        var list = [Double]()

        let weekStart = Date.today().previous(.monday, considerToday: true)
        workouts
            .filter { $0.endDate >= weekStart }
            .map{ $0.distanceInKilometers }
            .forEach { list.append($0) }

        return list
    }

    public var weeklyDistanceThisYear: [(Int, Double)] {
        var dict = Dictionary(grouping: workoutsThisYear) {
            Calendar.current.component(.weekOfYear, from: $0.endDate)
        }.mapValues { (weekGroup: [HKWorkout]) -> Double in
            weekGroup.reduce(0, { (result, workout) -> Double in
                result + workout.distanceInKilometers
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

    public var longestRun: HKWorkout? {
        let sorted = workouts.sorted { a, b in
            return a.distanceInKilometers > b.distanceInKilometers
        }

        return sorted.first
    }
}
