import HealthKit

public extension HKHealthStore {
    func requestAuthorization(completion: @escaping (Bool,Error?) -> Void) {
        let read = Set(arrayLiteral: HKWorkoutType.workoutType())
        requestAuthorization(toShare: nil, read: read, completion: completion)
    }
}
