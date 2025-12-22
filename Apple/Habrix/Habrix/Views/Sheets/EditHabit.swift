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

/**
 Struct to edit or initially create habits
 */
internal struct EditHabit: View {

    /// The current color scheme of the device environment
    @Environment(\.colorScheme) private var colorScheme

    /// Dismiss function of the environment used to close this as sheet
    @Environment(\.dismiss) private var dismiss

    /// ModelContext to store new habits or changes in
    @Environment(\.modelContext) private var modelContext

    /// All categories fetched from the Model Context
    @Query private var categories: [Category]

    /// The name of the habit
    @State private var name : String

    /// Description of the habit
    @State private var description : String

    /// Icon name as String. Can only be one of the icons selected via `IconPicker`
    @State private var iconName : String

    /// The frequency in which the habit should occur
    @State private var frequency : Frequency

    /// The category this habit belongs to
    @State private var category : Category

    /// Whether the icon picker sheet is shown or not
    @State private var iconPickerShown : Bool = false

    /// Whether or not the alert dialog which states, that the name field is empy,
    /// is shown
    @State private var nameEmptyDialogShown : Bool = false

    /// The start date of this habit
    @State private var startDate : Date = Date.now

    /// Whether this habit ends on some date
    @State private var useEndDate : Bool

    /// The end habit of this habit, if `useEndDate` is true
    @State private var endDate : Date

    /// Whether this view is used to edit or create a new habit
    /// `false`: create new habit
    /// `true`: edit existing habit
    @State private var editMode : Bool

    /// Whether notification for this habit should be active
    @State private var notify : Bool

    /// The habit to edit if `editMode` is set to `true`
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
        notify = false
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
        notify = internalHabit.notify
        editMode = true
        self.habit = habit
    }

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        TextField("Name", text: $name)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Picker(selection: $frequency) {
                            ForEach(Frequency.allCases) {
                                f in
                                Text(f.rawValue.capitalized).tag(f)
                            }
                        } label: {
                            Text("Frequency")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
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
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    } header: {
                        Text("General Data")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                    Section {
                        DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Toggle("End on some date", isOn: $useEndDate)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        if (useEndDate) {
                            DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                        }
                        Toggle("Send notifications", isOn: $notify)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    } header: {
                        Text("Time")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    } footer: {
                        Text("If no end date is set, the habit will always renew until manually stopped or deleted.")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
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

    /// Function called when editing or creation is done.
    /// Executes the parsing and storing functions and also creates habits
    /// and schedules notifications if wished
    private func done() {
        Task {
            do {
                try await NotificationHelper.requestPermission()
            } catch {
                // TODO: handle error
            }
        }
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
//            duration: nil,
            // TODO: add category (error was that category should be unique)
            category: nil,
            description: description.isEmpty ? nil : description,
            notify: notify
        )
        if habit.wrappedValue != nil {
            habit.wrappedValue = newHabit
            do {
                try modelContext.save()
            } catch _ {

            }
        } else {
            modelContext.insert(newHabit)
            Task {
                do {
                    try await HabitHelper.createExecutions(newHabit, modelContext: modelContext)
                } catch {
                    // TODO: handle error
                }
            }
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
