//
//  HabitsTimelineView.swift
//  Habrix
//
//  Created as TimelineView by Julian Schumacher on 17.10.25.
//
//  Renamed to HabitsTimelineView by Julian Schumacher on 22.10.25.
//

import SwiftUI
import SwiftData

/**
 This is the timeline view displaying all your upcoming and past executions.
 This is the default screen when opening the App.

 It displays all habit executions grouped by days with different styles for future and past ones as well as different styles
 for completed ones vs. uncompleted ones
 */
struct HabitsTimelineView: View {

    /// The executions fetched from the Database
    @Query private var habitExecutions : [HabitExecution]

    /// currently selected habit. This is set
    /// when the user taps on an execution to display the underlaying habit
    @State private var selectedHabit : Habit?

    /// Whether or not the details screen for habits is shown
    @State private var detailsShown : Bool = false

    /// whether or not the sheet to add a new habit is shown
    @State private var addShown : Bool = false

    var body: some View {
        NavigationSplitView {
            if habitExecutions.isEmpty {
                NoHabitsView()
                    .navigationTitle("Timeline")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.automatic)
#endif
            } else {
                buildHabitsTimeline()
                    .popover(isPresented: $detailsShown) {
                        HabitDetails(habit: $selectedHabit)
                    }
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                addShown.toggle()
                            } label: {
                                Label("Add habit", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $addShown) {
                        EditHabit()
                    }
                    .navigationTitle("Timeline")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.automatic)
#endif
            }
        } detail: {

        }
    }

    /**
     Returns the timeline build for all habits, sorted and grouped by days
     - Returns: The complete timeline for this view
     */
    @ViewBuilder
    private func buildHabitsTimeline() -> some View {
        let days = sortExecutionsIntoDays()
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .center, spacing: 8) {
                    ForEach(Array(days.keys).sorted(), id: \.self) {
                        day in
                        Section {
                            ForEach(Array(days[day]!).sorted(by: { $0.timestamp < $1.timestamp }), id: \.self) {
                                execution in
                                habitExecutionContainer(execution)
                                    .id(execution.timestamp)
                            }
                        } header: {
                            HStack {
                                Text(day, style: .date)
                                    .font(.headline)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                                Spacer()
                            }
                            .id(day)
                        } footer: {
                            Divider()
                        }
                    }
                }
                .padding(.vertical, 32)
            }
            .onAppear {
                let midnightToday = Calendar.current.startOfDay(for: Date.now)
                let todaysExecutions : [HabitExecution]  = days[midnightToday] ?? []
                let nextExecution : HabitExecution? = todaysExecutions.first(where: { $0.timestamp > Date.now })
                // Scroll to today
                DispatchQueue.main.async {
                    proxy.scrollTo(
                        nextExecution?.timestamp ?? Date.now,
                        anchor: .top
                    )
                }
            }
        }
    }


    /**
     Builds a single UI "container" for the execution passed to display in the timeline.
     This displays the title as well as the due date and applies a specific style depending on the timestamp and the state (checked or not)
     - Parameter execution: The execution to build the container for (name is function call is reducted)
     - Returns: a special container for a single habit execution
     */
    @ViewBuilder
    private func habitExecutionContainer(_ execution : HabitExecution) -> some View {
        HStack {
            Button {
                selectedHabit = execution.habit
                detailsShown.toggle()
            } label: {
                HStack {
                    Image(systemName: execution.habit?.iconName ?? "questionmark")
                    Text(execution.habit?.name ?? "Unknown")
                    Spacer()
                    Text(execution.timestamp.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }
            Button {
                execution.isCompleted.toggle()
            } label: {
                Image(systemName: execution.isCompleted ? "checkmark.circle" : "circle")
            }
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, minHeight: 30, idealHeight: 40, maxHeight: 75)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .glassEffect(getGlassEffectFor(execution: execution))
        .padding(.horizontal, 32)
    }


    /**
     Returns the glass effect for a habit execution depending on timestamp and checked state
     - Parameter execution: The execution to build the glass style for
     */
    private func getGlassEffectFor(execution : HabitExecution) -> Glass {
        // TODO: work on return values
        if (execution.timestamp < Date.now) {
            if (execution.isCompleted) {
                return .regular.tint(.secondary.opacity(0.5))
            } else {
                return .regular.tint(.gray.opacity(0.6))
            }
        } else {
            if (execution.isCompleted) {
                return .regular.tint(.secondary.opacity(0.3))
            } else {
                return .regular.tint(.clear)
            }
        }
    }


    /**
     Sorts the execution into days
     - Returns: a map of date to an array of executions
     */
    private func sortExecutionsIntoDays() -> [Date : [HabitExecution]] {
        return Dictionary(grouping: habitExecutions, by: { Calendar.current.startOfDay(for: $0.timestamp)
        })
    }
}

#Preview {
    HabitsTimelineView()
        .modelContainer(for: Habit.self, inMemory: true)
}
