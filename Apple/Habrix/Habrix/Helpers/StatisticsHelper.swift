//
//  StatisticsHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

/// Helper class for staticstics related actions and background tasks
internal struct StatisticsHelper {

#warning("Method unfinished - still partly returning nonsense")
    /**
     Calculates and creates the statistics based on the passed habits list. For most accurate statistics, pass all habits.
     Currently the following statistics are calculated:
     - executions completed today
     - current streak in days
     - Parameter habits: The list of habits to calculate statistics on
     - Returns: A `statistics` object with statics for the passed habits
     */
    internal static func getStatistics(habits : [Habit]) -> Statistics {
        // TODO: execution.timestamp == Date.now does not work, because it includes the timestamp and not only day
        let habitsDueToday = habits.filter {
            habit in
            habit.executions!.contains(where: {
                execution in
                execution.timestamp == Date.now
            })
        }
        var executionsDueToday : [HabitExecution] = []
        habitsDueToday.forEach {
            executionsDueToday.append(contentsOf: $0.executions!.filter { $0.timestamp == Date.now })
        }
        let completedExecutionsDueToday : [HabitExecution] = executionsDueToday.filter { $0.isCompleted }
        return Statistics(
            currentStreak: KeyValueStorage.getCurrentStreak(),
            habitsCompletedToday: completedExecutionsDueToday.count,
            totalHabits: executionsDueToday.count
        )
    }
}
