import Foundation

public struct ProgressCalculator {
    private let goalRepository: GoalRepository
    private let workoutRepository: WorkoutRepository

    public init(goalRepository: GoalRepository, workoutRepository: WorkoutRepository) {
        self.goalRepository = goalRepository
        self.workoutRepository = workoutRepository
    }

    public func yearlyProgress() -> wtrackKit.Progress {
        let goalDistance = (Double(goalRepository.kilometersPerWeek) / 7.0) * 365.0
        let curDistance = workoutRepository.totalKilometersThisYear
        return SimpleProgress(currentValue: curDistance, goalValue: goalDistance)
    }

    public func weeklyProgress() -> WeeklyProgressViewModel {
        let goalDistance = goalRepository.kilometersPerWeek
        let workouts = workoutRepository.workoutLengthsThisWeek

        return WeeklyProgressViewModel(goalDistance: goalDistance, weeklyDistances: workouts)
    }
}
