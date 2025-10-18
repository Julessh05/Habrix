//
//  TimelineView.swift
//  Habrix
//
//  Created by Julian Schumacher on 17.10.25.
//

import SwiftUI

struct TimelineView: View {

    internal var habits : [Habit]

    @Binding internal var selectedHabit : Habit?

    @Binding internal var detailsShown : Bool

    var body: some View {
        NavigationSplitView {
            buildList()
            .navigationTitle("Executions")
            .navigationBarTitleDisplayMode(.automatic)
        } detail: {

        }
    }

    @ViewBuilder
    private func buildList() -> some View {
        let nextExecutions = habits.getNextExecutions()
        List {
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

    @ViewBuilder
    private func habitExecutionContainer(_ execution : HabitExecution) -> some View {
        Button {
            selectedHabit = execution.habit
            detailsShown.toggle()
        } label: {
            HStack {
                Text(execution.habit.name)
                Spacer()
                Text(execution.timestamp, style: .date)
            }
        }
    }
}

#Preview {

    @Previewable @State var habits : [Habit] = []

    @Previewable @State var detailsShown : Bool = false

    @Previewable @State var selectedHabit : Habit? = nil

    TimelineView(
        habits: habits,
        selectedHabit: $selectedHabit,
        detailsShown: $detailsShown
    )
}
