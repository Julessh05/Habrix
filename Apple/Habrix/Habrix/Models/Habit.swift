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
    @Attribute(.unique, .allowsCloudEncryption) internal var name : String

    @Attribute(.allowsCloudEncryption) internal var iconName : String

    @Attribute(.allowsCloudEncryption) internal var frequency : Frequency

    @Attribute(.allowsCloudEncryption) internal var startDate : Date

    @Attribute(.allowsCloudEncryption) internal var endDate : Date?

    @Attribute(.allowsCloudEncryption) internal var category : Category?

    @Attribute(.allowsCloudEncryption) internal var habitDescription : String = ""

    @Relationship(deleteRule: .cascade, inverse: \HabitExecution.habit) internal var executions : [HabitExecution] = []

    internal init(
        name : String,
        iconName : String,
        frequency : Frequency,
        startDate : Date = Date.now,
        endDate : Date? = nil,
        category : Category? = nil,
    ) {
        self.name = name
        self.iconName = iconName
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
    }
}
