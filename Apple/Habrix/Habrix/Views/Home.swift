//
//  Home.swift
//  Habrix
//
//  Created as ContentView.swift by Julian Schumacher on 27.09.25.
//
//  Renamed to Home.swift by Julian Schumacher on 01.10.25
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var habits: [Habit]

    @State private var addShown : Bool = false

    @State private var selectedHabit : Habit? = nil

    @State private var detailsShown : Bool = false

    var body: some View {
        NavigationSplitView {
            ZStack {
                VStack {
                    if (habits.isEmpty) {
                        Spacer()
                        VStack {
                            Image(systemName: "questionmark.folder")
                                .symbolColorRenderingMode(.gradient)
                                .renderingMode(.template)
                                .symbolRenderingMode(.multicolor)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 200)
                            Text("No habits found")
                                .padding(12)
                            Button("Add new one") {
                                addShown.toggle()
                            }
                            .padding(12)
                            .foregroundStyle(.white)
                            .glassEffect(.regular.tint(.blue))
                        }
                        .frame(width: 200, height: 400)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .glassEffect(.regular.interactive())
                        Spacer()
                    } else {
                        List {
                            ForEach(habits) {
                                habit in
                                habitContainer(habit)
                            }
                            .onDelete(perform: deleteHabit)
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button {
                        addShown.toggle()
                    } label: {
                        Label("Add habit", systemImage: "plus")
                            .foregroundStyle(.foreground)
                    }
                    .padding(16)
                    .glassEffect(.regular)
                    .popover(isPresented: $addShown) {
                        EditHabit()
                    }
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
#if os(iOS)
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.automatic)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button {
                        addShown.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .glassEffect()
                }
            }
            .popover(isPresented: $detailsShown) {
                HabitDetails(habit: $selectedHabit)
            }
        } detail: {
            Text("Select an item")
        }
    }

    @ViewBuilder
    private func habitContainer(_ habit : Habit) -> some View {
        Button {
            selectedHabit = habit
            detailsShown.toggle()
        } label: {
            HStack {
                Image(systemName: habit.iconName)
                Text(habit.name)
            }
        }
    }

    private func deleteHabit(at offset: IndexSet) {
        withAnimation {
            for index in offset {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    Home()
        .modelContainer(for: Habit.self, inMemory: true)
}
