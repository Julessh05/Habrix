//
//  Habit.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import Foundation
import SwiftData

@Model
final class Habit {
    @Attribute(.allowsCloudEncryption) internal var name : String = "HABIT DEFAULT NAME"

    @Attribute(.allowsCloudEncryption) internal var iconName : String = "figure.walk"

    @Attribute(.allowsCloudEncryption) internal var frequency : Frequency = Frequency.monthly

    @Attribute(.allowsCloudEncryption) internal var startDate : Date = Date.now

    @Attribute(.allowsCloudEncryption) internal var endDate : Date?

    @Relationship(deleteRule: .cascade, inverse: \Category.habits) internal var category : Category?

    @Attribute(.allowsCloudEncryption) internal var habitDescription : String?

    @Relationship(deleteRule: .cascade, inverse: \HabitExecution.habit) internal var executions : [HabitExecution]? = []

    internal init(
        name : String,
        iconName : String,
        frequency : Frequency,
        startDate : Date = Date.now,
        endDate : Date? = nil,
        category : Category? = nil,
        description : String? = nil
    ) {
        self.name = name
        self.iconName = iconName
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.habitDescription = description
    }

    internal func getNextExecution() -> HabitExecution? {
        executions!.min(by: { $0.timestamp > Date.now && $1.timestamp > Date.now && $0.timestamp < $1.timestamp }) // All Dates in the future. On them, get the smallest element
    }
}
