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

struct HabitsTimelineView: View {

    @Query private var habits : [Habit]

    @State private var selectedHabit : Habit?

    @State private var detailsShown : Bool = false

    @State private var addShown : Bool = false

    var body: some View {
        NavigationSplitView {
            let nextExecutions = habits.getNextExecutions()
            if habits.isEmpty {
                NoHabitsView()
                    .navigationTitle("Timeline")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.automatic)
                #endif
            } else {
                ScrollView {
                    HStack(alignment: .top) {
                        Text("Today")
                            .padding(16)
                        Rectangle()
                            .frame(width: 2)
                            .padding(.leading, 16)
                        LazyVStack {
                            ForEach(Array(nextExecutions.keys), id: \.self) {
                                date in
                                Section(date.description) {
                                    ForEach(Array(nextExecutions[date] ?? []), id: \.self) {
                                        execution in
                                        habitExecutionContainer(execution)
                                    }
                                }
                            }
                        }
                    }
                }
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
                .popover(isPresented: $addShown) {
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

    @ViewBuilder
    private func habitExecutionContainer(_ execution : HabitExecution) -> some View {
        Button {
            selectedHabit = execution.habit
            detailsShown.toggle()
        } label: {
            HStack {
                Text(execution.habit!.name)
                Spacer()
                Text(execution.timestamp, style: .date)
            }
        }
    }
}

#Preview {
    HabitsTimelineView()
        .modelContainer(for: Habit.self, inMemory: true)
}
