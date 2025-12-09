//
//  StatisticsHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

internal struct StatisticsHelper {

#warning("Method unfinished - still partly returning nonsense")
    // TODO: execution.timestamp == Date.now does not work, because it includes the timestamp and not only day
    internal static func getStatistics(habits : [Habit]) -> Statistics {
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
