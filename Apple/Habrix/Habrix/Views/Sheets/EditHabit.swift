//
//  EditHabit.swift
//  Habrix
//
//  Created as AddHabit.swift by Julian Schumacher on 01.10.25.
//
//  Renamed to EditHabit.swift by Julian Schumacher on 11.10.25
//

import SwiftUI
import SwiftData

internal struct EditHabit: View {

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Query private var categories: [Category]

    @State private var name : String

    @State private var description : String

    @State private var iconName : String

    @State private var frequency : Frequency

    @State private var category : Category

    @State private var iconPickerShown : Bool = false

    @State private var nameEmptyDialogShown : Bool = false

    @State private var startDate : Date = Date.now

    @State private var useEndDate : Bool

    @State private var endDate : Date

    @State private var editMode : Bool

    private let habit : Binding<Habit?>

    internal init() {
        name = ""
        description = ""
        iconName = "figure.walk"
        frequency = .monthly
        category = Category.empty
        startDate = Date.now
        useEndDate = false
        endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date.now)!
        editMode = false
        habit = .constant(nil)
    }

    internal init(_ habit : Binding<Habit?>) {
        guard let internalHabit = habit.wrappedValue else {
            exit(1)
        }
        name = internalHabit.name
        description = internalHabit.habitDescription ?? ""
        iconName = internalHabit.iconName
        frequency = internalHabit.frequency
        category = internalHabit.category ?? Category.empty
        startDate = internalHabit.startDate
        useEndDate = internalHabit.endDate != nil
        endDate = internalHabit.endDate ?? Calendar.current.date(byAdding: .year, value: 1, to: Date.now)!
        editMode = true
        self.habit = habit
    }

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        TextField("Name", text: $name)
                        Picker(selection: $frequency) {
                            ForEach(Frequency.allCases) {
                                f in
                                Text(f.rawValue).tag(f)
                            }
                        } label: {
                            Text("Frequency")
                        }
                        Button {
                            iconPickerShown.toggle()
                        } label: {
                            Label("Icon", systemImage: iconName)
                        }
                        .foregroundStyle(.foreground)
                        .popover(isPresented: $iconPickerShown) {
                            IconPicker(iconName: $iconName)
                        }
                        TextField("Description", text: $description, axis: .vertical)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3...5)
                    } header: {
                        Text("General Data")
                    }
                    Section {
                        DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        Toggle("End on some date", isOn: $useEndDate)
                        if (useEndDate) {
                            DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                        }
                    } header: {
                        Text("Time")
                    } footer: {
                        Text("If no end date is set, the habit will always renew until manually stopped or deleted.")
                    }
                    .datePickerStyle(.automatic)
                }
                VStack {
                    Spacer()
                    Button {
                        done()
                    } label: {
                        Label("Add", systemImage: "plus")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 128)
                    }
                    // TODO: either disabled or alert dialog on empty name
                    .foregroundStyle(.foreground)
                    .glassEffect(.regular)
                }
                .ignoresSafeArea(.keyboard)
            }
            .toolbarRole(.automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: { dismiss() }) {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        done()
                    } label: {
                        Label("Add", systemImage: "checkmark")
                    }
                }
            }
#if os(iOS)
            .navigationTitle(editMode ? "Edit \(habit.wrappedValue?.name ?? "Unknown Habit")" : "Add Habit")
            .navigationBarTitleDisplayMode(.automatic)
#endif
        }
    }

    private func done() {
        guard !name.isEmpty else {
            nameEmptyDialogShown.toggle()
            return
        }
        let newHabit = Habit(
            name: name,
            iconName: iconName,
            frequency: frequency,
            startDate: startDate,
            endDate: useEndDate ? endDate : nil,
            // TODO: add category (error was that category should be unique)
            category: nil,
            description: description.isEmpty ? nil : description
        )
        if habit.wrappedValue != nil {
            habit.wrappedValue = newHabit
            do {
                try modelContext.save()
            } catch _ {

            }
        } else {
            modelContext.insert(newHabit)
            HabitHelper.createExecusions(newHabit, modelContext: modelContext)
        }
        dismiss()
    }
}

#Preview("Add new habit") {
    EditHabit()
}

#Preview("Edit minimal habit") {
    @Previewable @State var habit : Habit? = Habit(
        name: "Test",
        iconName: "figure.walk",
        frequency: .monthly
    )

    EditHabit($habit)
}

#Preview("Edit ended habit") {
    @Previewable @State var habit : Habit? = Habit(
        name: "Test",
        iconName: "figure.walk",
        frequency: .monthly,
        endDate: Date.distantFuture,
    )

    EditHabit($habit)
}

#Preview("Edit habit w/ discription") {
    @Previewable @State var habit : Habit? = Habit(
        name: "Test",
        iconName: "figure.walk",
        frequency: .monthly,
        description: "Test description"
    )

    EditHabit($habit)
}
