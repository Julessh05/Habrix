//
//  HabitHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 09.10.25.
//

import Foundation
import SwiftData

internal class HabitHelper {

    /// checks the saved and scheduled executions for a habit and created new ones if necessary
    internal static func createExecusions(_ habit : Habit, modelContext : ModelContext) {
        let count = habit.executions!.count(where: { $0.timestamp > Date.now })
        guard count  < 100 else { return /* Enough executions cached */ }
        let lastTimeStamp : Date
        if count == 0 {
            lastTimeStamp = habit.startDate
        } else {
            lastTimeStamp = habit.executions!.max(by: { $0.timestamp < $1.timestamp })!.timestamp
        }
        for i in 0..<(100 - count) {
            let newTimeStamp = Calendar.current.date(
                byAdding: habit.frequency.getCalendarComponent(),
                value: i,
                to: lastTimeStamp
            )!
            if habit.endDate != nil && newTimeStamp > habit.endDate! { break }
            modelContext.insert(HabitExecution(timestamp: newTimeStamp, habit: habit))
        }
    }

    internal static func deleteExecutions(_ habit : Habit, modelContext : ModelContext) {
        for execution in habit.executions! {
            modelContext.delete(execution)
        }
    }
}
