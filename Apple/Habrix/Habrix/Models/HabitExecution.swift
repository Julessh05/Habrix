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

    @Attribute(.allowsCloudEncryption) internal var timestamp : Date

    internal var habit : Habit

    internal init(timestamp : Date, habit : Habit) {
        self.timestamp = timestamp
        self.habit = habit
    }
}
