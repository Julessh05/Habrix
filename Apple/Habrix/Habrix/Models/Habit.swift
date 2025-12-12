//
//  Habit.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import Foundation
import SwiftData

/// A single habit to track
@Model
final class Habit {
    /// The name of this habit. Has a default value, so can't be nil
    @Attribute(.allowsCloudEncryption) internal var name : String = "HABIT DEFAULT NAME"

    /// The name of the system sf icon mapped to this habit.
    /// Defaults to the `figure.walk` icon
    @Attribute(.allowsCloudEncryption) internal var iconName : String = "figure.walk"

    /// The frequency in which this habit renews
    @Attribute(.allowsCloudEncryption) internal var frequency : Frequency = Frequency.monthly

    /// The first timestamp this habit becomes active in. Defaults to the current date and time
    @Attribute(.allowsCloudEncryption) internal var startDate : Date = Date.now

    /// An optional end date.
    /// If the habit end sometime, it's stored in this attribute
    @Attribute(.allowsCloudEncryption) internal var endDate : Date?

//    @Attribute(.allowsCloudEncryption) internal var duration : Int?

    /// The category this habit belongs to.
    /// This is optional and defaults to `nil`
    @Relationship(deleteRule: .cascade, inverse: \Category.habits) internal var category : Category?

    ///The optional precise description provided to this habit
    ///Defaults to `nil`
    @Attribute(.allowsCloudEncryption) internal var habitDescription : String?

    /// all executions for this habit.
    /// This relationship has a cascade rule meaning all executions are deleted, when a habit is deleted
    @Relationship(deleteRule: .cascade, inverse: \HabitExecution.habit) internal var executions : [HabitExecution]? = []

    internal init(
        name : String,
        iconName : String,
        frequency : Frequency,
        startDate : Date = Date.now,
        endDate : Date? = nil,
//        duration : Int? = nil,
        category : Category? = nil,
        description : String? = nil
    ) {
        self.name = name
        self.iconName = iconName
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
//        self.duration = duration
        self.category = category
        self.habitDescription = description
    }

    /// Returns the next Execution if found, nil otherwise
    /// - Returns: the next execution as `HabitExecution` if applicable, `nil` otherwise
    internal func getNextExecution() -> HabitExecution? {
        executions!.min(by: { $0.timestamp > Date.now && $1.timestamp > Date.now && $0.timestamp < $1.timestamp }) // All Dates in the future. On them, get the smallest element
    }
}
