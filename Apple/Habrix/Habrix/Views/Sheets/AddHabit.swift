//
//  AddHabit.swift
//  Habrix
//
//  Created by Julian Schumacher on 01.10.25.
//

import SwiftUI
import SwiftData

internal struct AddHabit: View {

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    @Query private var categories: [Category]

    @State private var name : String = ""

    @State private var description : String = ""

    @State private var iconName : String = "figure.walk"

    @State private var frequency : Frequency = .monthly

    @State private var category : Category = Category.empty

    @State private var iconPickerShown : Bool = false

    @State private var nameEmptyDialogShown : Bool = false

    @State private var startDate : Date = Date.now

    @State private var useEndDate : Bool = false

    @State private var endDate : Date = Calendar.current.date(byAdding: .year, value: 1, to: Date.now)!

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
                        DatePicker("Start", selection: $startDate, displayedComponents: .date)
                        Toggle("End on some date", isOn: $useEndDate)
                        if (useEndDate) {
                            DatePicker("End", selection: $endDate, displayedComponents: .date)
                        }
                    } header: {
                        Text("Time")
                    } footer: {
                        Text("If no end date is set, the habit will always renew until manually stopped or deleted.")
                    }
                    .datePickerStyle(.automatic)
//                    Section {
//                        Picker(selection: $category) {
//                            Text("None").tag(Category.empty)
//                            Divider()
//                            ForEach(categories) {
//                                cat in
//                                Text(cat.name)
//                            }
//                            Divider()
//                            Button {
//                                // TODO: implement button (if possible)
//                            } label: {
//                                Label("Add new category", systemImage: "plus")
//                            }
//                        } label: {
//                            Label("Category", systemImage: "tag")
//                        }
//                    } header: {
//                        Text("Customization")
//                    } footer: {
//                        VStack(alignment: .leading) {
//                            Text("Furthermore configure your habit to personal preferences")
//                            HStack {
//                                Text("You can add this habit to a category or")
//                                Text("Create a new one")
//                                Text(".")
//                            }
//                        }
//                    }
                }
                VStack {
                    Spacer()
                    Button {
                        done()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    // TODO: either disabled or alert dialog on empty name
                    .padding(.vertical, 16)
                    .padding(.horizontal, 128)
                    .foregroundStyle(.foreground)
                    .glassEffect(.regular)
                }
                .ignoresSafeArea(.keyboard)
            }
            //            VStack {
            //                ZStack {
            //                    LinearGradient(
            //                        colors: [.pink.opacity(0.2), .blue.opacity(0.2)],
            //                        startPoint: .topLeading,
            //                        endPoint: .bottomTrailing
            //                    )
            //                    Button {
            //                        iconPickerShown.toggle()
            //                    } label: {
            //                        Image(systemName: iconName)
            //                            .resizable()
            //                            .scaledToFit()
            //                            .symbolColorRenderingMode(.gradient)
            //                            .symbolRenderingMode(.hierarchical)
            //                    }
            //                    .foregroundStyle(.black)
            //                    .padding(32)
            //                    .popover(isPresented: $iconPickerShown) {
            //                        IconPicker(iconName: $iconName)
            //                    }
            //                }
            //                .frame(width: 196, height: 196)
            //                .glassEffect(
            //                    .clear.interactive(),
            //                    in: RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
            //                )
            //                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)))
            //                .padding(.vertical, 64)
            //                .padding(.horizontal, 32)
            //                TextField("Name", text: $name)
            //                    .padding(12)
            //                    .backgroundStyle(.clear)
            //                    .glassEffect(.regular.interactive())
            //                    .padding(32)
            //                    .alert("Empty name", isPresented: $nameEmptyDialogShown) {
            //
            //                    } message: {
            //                        Text("An unnamed habit cannot be stored. Please enter a name")
            //                    }
            //                Picker(selection: $frequency) {
            //                    ForEach(Frequency.allCases) {
            //                        f in
            //                        Text(String(describing: f)).tag(f)
            //                    }
            //                } label: {
            //                    Label(String(describing: frequency), systemImage: "hourglass")
            //                        .glassEffect()
            //                }
            //                .tint(.white)
            //                Spacer()
            //                Button {
            //                    done()
            //                } label: {
            //                    Label("Add", systemImage: "plus")
            //                }
            //                // TODO: either disabled or alert dialog on empty name
            //                .padding(.vertical, 16)
            //                .padding(.horizontal, 128)
            //                .foregroundStyle(.foreground)
            //                .glassEffect(.regular)
            //            }
            //            .background {
            //                MeshGradient(
            //                    width: 2,
            //                    height: 2,
            //                    points: [
            //                        [0, 0], [1, -0.3], [0, 1], [1, 1]
            //                    ],
            //                    colors: [
            //                        .purple, .mint,
            //                        .orange, .blue
            //                    ],
            //                )
            //                .ignoresSafeArea()
            //                .blur(radius: 15)
            //                Color.black.opacity(0.3).ignoresSafeArea()
            //            }
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
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.automatic)
#endif
        }
    }

    private func done() {
        guard !name.isEmpty else {
            nameEmptyDialogShown.toggle()
            return
        }
        let habit = Habit(
            name: name,
            iconName: iconName,
            frequency: frequency,
            startDate: startDate,
            endDate: useEndDate ? endDate : nil,
            category: category,
            description: description.isEmpty ? nil : description
        )
        modelContext.insert(habit)
        HabitHelper.createExecusions(habit, modelContext: modelContext)
        dismiss()
    }
}

#Preview {
    AddHabit()
}
