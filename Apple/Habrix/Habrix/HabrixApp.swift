//
//  HabrixApp.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import SwiftUI
import SwiftData

@main
struct HabrixApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            HabitExecution.self,
            Category.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Home()
                .onAppear {
                    SettingsHelper.loadSettings()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
