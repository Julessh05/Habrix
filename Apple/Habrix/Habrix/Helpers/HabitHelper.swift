//
//  HabitHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 09.10.25.
//

import Foundation
import SwiftData
import UserNotifications

/// Helper class for habits to capture all methods related to habit organistaion
internal class HabitHelper {

    /// checks the saved and scheduled executions for a habit and created new ones if necessary
    /// - Parameter habit: The habit to create executions for
    /// - Parameter modelContext: SwiftData content to work in
    /// - Throws an error if notification methods throw errors
    internal static func createExecutions(_ habit : Habit, modelContext : ModelContext) async throws {
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
        // TODO: next notification is only scheduled, when new executions are created. Because only the next execution in scheduled, this code has to be called every time
        if habit.notify {
            try await scheduleNotification(execution: habit.getNextExecution()!)
        }
    }

    /**
     Schedules a local notification for the passed execution.
     This is not repeaded, so every executions need to be configured individually.
     Does also check if notifications are wished on habit of the provided execution.
     Returns if notify is set to false.
     - Parameter execution: the execution to schedule a notification for
     - Throws: an error if notification center methods throw errors
     */
    internal static func scheduleNotification(execution : HabitExecution) async throws {
        // Check
        guard execution.habit!.notify else { return }
        // Check permissions
        let settings = await NotificationHelper.getSettings()
        guard settings.authorizationStatus == .authorized else { return }
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = execution.habit!.name
        content.body = execution.timestamp.ISO8601Format(.iso8601)
        content.categoryIdentifier = "habit-execution"
        content.sound = .default
        // create trigger
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [
                .year,
                .month,
                .day,
                .hour,
                .minute,
                ],
                from: execution.timestamp),
            repeats: false
        )
        // Create notification
        let notificationRequest = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        NotificationHelper.scheduleNotification(request: notificationRequest)
    }

    /// Deletes all the execution for the specified habit
    /// - Parameter habit: The habit to delete the executions for
    /// - Parameter modelContext: SwiftData content to work in
    internal static func deleteExecutions(_ habit : Habit, modelContext : ModelContext) {
        for execution in habit.executions! {
            modelContext.delete(execution)
        }
    }
}
