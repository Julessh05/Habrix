//
//  HabitDetails.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import SwiftUI

struct HabitDetails: View {

    @Environment(\.dismiss) private var dismiss

    @Binding internal var habit : Habit?

    private static let loadingTag : String = "Loading..."

    var body: some View {
        NavigationStack {
            List {
                Section {
                    detailsRow(text: "Name", value: habit?.name ?? HabitDetails.loadingTag)
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

                    } label: {
                        Label("Mark next execution as done", systemImage: "checkmark")
                    }
                    ForEach(habit?.executions ?? []) {
                        execution in
                        Text(execution.timestamp.description)
                    }
                    // Section for next executions
                } header: {
                    Text("Executions")
                } footer: {
                    Text("The next <X> executions are shown here. If the habit does not end, new ones will be scheduled automatically.")
                }
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
