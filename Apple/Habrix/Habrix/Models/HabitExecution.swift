//
//  HabitExecution.swift
//  Habrix
//
//  Created by Julian Schumacher on 07.10.25.
//

import Foundation
import SwiftData

@Model
internal final class HabitExecution {

    @Attribute(.allowsCloudEncryption) internal var timestamp : Date = Date.now

    internal var habit : Habit?

    @Attribute(.allowsCloudEncryption) internal var isCompleted : Bool = false

    internal init(timestamp : Date, habit : Habit) {
        self.timestamp = timestamp
        self.habit = habit
    }

    internal func markAsDone() {
        isCompleted = true
    }

    internal func markAsUndone() {
        isCompleted = false
    }
}

extension [Habit] {
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
