//
//  Statistics.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

/// Statistics Object containing all statistics in this app
internal struct Statistics {

    /// The current streak in days.
    /// This means days in a row, the user completed all habits on
    internal var currentStreak : Int

    /// The number of habits the user completed on the current day
    internal var habitsCompletedToday : Int

    /// The total number of habits in this app
    /// (or passed to calculate this habit)
    internal var totalHabits : Int

    internal init(currentStreak: Int, habitsCompletedToday: Int, totalHabits: Int) {
        self.currentStreak = currentStreak
        self.habitsCompletedToday = habitsCompletedToday
        self.totalHabits = totalHabits
    }
}
