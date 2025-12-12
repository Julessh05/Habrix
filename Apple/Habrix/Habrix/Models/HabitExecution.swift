//
//  HabitExecution.swift
//  Habrix
//
//  Created by Julian Schumacher on 07.10.25.
//

import Foundation
import SwiftData

/// A single execution for a habit.
/// Every execution is an execution at a single timestamp
@Model
internal final class HabitExecution {

    /// The timestamp this executions maps to
    @Attribute(.allowsCloudEncryption) internal var timestamp : Date = Date.now

    /// The habit this object is an execution for
    internal var habit : Habit?

    /// Whether or not this execution of the habit has already been completed
    @Attribute(.allowsCloudEncryption) internal var isCompleted : Bool = false

    internal init(timestamp : Date, habit : Habit) {
        self.timestamp = timestamp
        self.habit = habit
    }

    /// Mark the execution as done.
    /// Sets the `isCompleted`
    internal func markAsDone() {
        isCompleted = true
    }

    /// Mark the execution as uncompleted
    /// Sets the `isCompleted`
    internal func markAsUndone() {
        isCompleted = false
    }
}

/// An extension for a habit list
extension [Habit] {

    /**
     Get the next execution on a list of habits.
     Maps all executions to a single date (day). Returns a map of date to a list of habit executions on that date.
     Every execution is mapped to some day, so all days which executions are scheduled for will be contained in the map keys.
     - Returns: A map of a date to all executions on that particular date
     */
    internal func getNextExecutions() -> [Date : [HabitExecution]] {
        var res : [Date : [HabitExecution]] = [:]
        // TODO: find cleaner solution
        for habit in self {
            if let nextExecution = habit.getNextExecution() {
                let nextTimestamp = nextExecution.timestamp
                if res[nextTimestamp] == nil {
                    res[nextTimestamp] = []
                }
                res[nextTimestamp]!.append(nextExecution)
            }
        }
        return Dictionary(uniqueKeysWithValues: res.sorted(by: { $0.key < $1.key }))
        //return res.sorted(by: { $0.key < $1.key }) as [Date : [HabitExecution]]
    }
}
