//
//  HabitOverview.swift
//  Habrix
//
//  Created by Julian Schumacher on 17.10.25.
//

import SwiftUI
import SwiftData

struct HabitOverview: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var habits : [Habit]

    @State private var selectedHabit : Habit?

    @State private var detailsShown : Bool = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habits) {
                    habit in
                    habitContainer(habit)
                }
                // TODO: implement confirm dialog on delete
                .onDelete(perform: deleteHabit)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        // TODO: implement done
                    } label: {
                        Label("Mark as done", systemImage: "checkmark")
                    }
                    .tint(.accentColor)
                }
            }
            .popover(isPresented: $detailsShown) {
                HabitDetails(habit: $selectedHabit)
            }
            .navigationTitle("Habits")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.automatic)
            #endif
        } detail: {
            
        }
    }

    private func deleteHabit(at offset: IndexSet) {
        withAnimation {
            for index in offset {
                HabitHelper.deleteExecutions(habits[index], modelContext: modelContext)
                modelContext.delete(habits[index])
            }
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
            .foregroundStyle(.foreground)
        }
    }
}

#Preview {
    HabitOverview()
}
