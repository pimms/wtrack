import HealthKit

public extension HKWorkout {
    var distanceInKilometers: Double {
        return (totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000
    }
}
