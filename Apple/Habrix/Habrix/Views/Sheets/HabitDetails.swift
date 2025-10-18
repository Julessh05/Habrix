//
//  HabitDetails.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import SwiftUI
import SwiftData

struct HabitDetails: View {

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Binding internal var habit : Habit?

    private static let loadingTag : String = "Loading..."

    @State private var futureExecutions : [HabitExecution] = []

    @State private var pastExecutions : [HabitExecution] = []

    @State private var editShown : Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    detailsRow(text: "Name", value: habit?.name ?? HabitDetails.loadingTag)
                    detailsRow(
                        text: "Frequency",
                        value: habit?.frequency.rawValue.capitalized ?? HabitDetails.loadingTag
                    )
                    VStack(alignment: .leading) {
                        Text("Description")
                        Text(habit?.habitDescription ?? "No description provided")
                            .foregroundStyle(.gray)
                    }
                } header: {
                    Text("Details")
                }
                Section {
                    detailsRow(text: "Start", value: habit?.startDate.description ?? HabitDetails.loadingTag)
                    if habit?.endDate != nil {
                        detailsRow(text: "End", value: habit?.endDate?.description ?? HabitDetails.loadingTag)
                    }
                } header: {
                    Text("Limits")
                }
                Section {
                    Button {
                        markNextExecutionAsDone()
                    } label: {
                        Label("Mark next execution as done", systemImage: "checkmark")
                    }
                    ForEach(futureExecutions) {
                        execution in
                        Text(execution.timestamp.description)
                    }
                } header: {
                    Text("Executions")
                } footer: {
                    Text("The next 10 due dates are shown here. If the habit does not end, new ones will be scheduled automatically.")
                }
                Section {
                    ForEach(pastExecutions) {
                        execution in
                        Label(execution.timestamp.description, systemImage: execution.isCompleted ? "checkmark" : "xmark")
                            .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Past executions")
                } footer: {
                    Text("The past 10 due dates of this habit")
                }
            }
            .popover(isPresented: $editShown) {
                EditHabit($habit)
            }
            .onAppear {
                let futureSlice = habit?.executions.filter { $0.timestamp > Date.now } ?? []
                futureExecutions = Array(futureSlice.prefix(10))
                let pastSlice = habit?.executions.filter { $0.timestamp <= Date.now } ?? []
                pastExecutions = Array(pastSlice.prefix(10))
            }
            #if os(iOS)
            .navigationTitle(habit?.name ?? HabitDetails.loadingTag)
            .navigationBarTitleDisplayMode(.automatic)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        editShown.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func detailsRow(text : String, value : String) -> some View {
        HStack {
            Text(text)
            Spacer()
            Text(value)
                .foregroundStyle(.gray)
        }
    }

    private func markNextExecutionAsDone() {
        let nextExecution : HabitExecution? = habit!.getNextExecution()
        if nextExecution != nil {
            nextExecution!.markAsDone()
        }
        HabitHelper.createExecusions(habit!, modelContext: modelContext)
    }
}

#Preview("unlimited") {
    @Previewable @State var habit: Habit? = Habit(
        name: "Test",
        iconName: "figure.walk",
        frequency: .monthly,
        startDate: Date.now
    )

    HabitDetails(habit: $habit)
}

#Preview("enddate limited") {
    @Previewable @State var habit: Habit? = Habit(
        name: "Test",
        iconName: "figure.walk",
        frequency: .monthly,
        startDate: Date.now,
        endDate: Date.distantFuture
    )

    HabitDetails(habit: $habit)
}
