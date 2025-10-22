//
//  Statistics.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

internal struct Statistics {

    internal var currentStreak : Int

    internal var habitsCompletedToday : Int

    internal var totalHabits : Int

    internal init(currentStreak: Int, habitsCompletedToday: Int, totalHabits: Int) {
        self.currentStreak = currentStreak
        self.habitsCompletedToday = habitsCompletedToday
        self.totalHabits = totalHabits
    }
}
