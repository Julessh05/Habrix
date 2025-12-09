//
//  SearchView.swift
//  Habrix
//
//  Created by Julian Schumacher on 14.10.25.
//

import SwiftUI
import SwiftData

struct SearchView: View {

    @Query private var habits : [Habit]

    @State private var searchText : String = ""

    @State private var selectedHabit : Habit?

    @State private var detailsShown : Bool = false

    @State private var filteredList : [Habit] = []

    var body: some View {
        NavigationSplitView {
            if searchText.isEmpty {
                List {
//                    NavigationLink("Today") {
//
//                    }
//                    NavigationLink("Ending soon") {
//
//                    }
                    if !habits.isEmpty {
                        NavigationLink("All habits") {
                            HabitOverview()
                        }
                    } else {
                        Text("Add your first habit to see more options")
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Discover")
#if os(iOS)
                .navigationBarTitleDisplayMode(.automatic)
#endif
            } else {
                if filteredList.isEmpty {
                    VStack {
                        Image(systemName: "questionmark")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 160)
                            .padding(.vertical, 32)
                        Text("No matches found, try something else")
                    }
                } else {
                    List(filteredList) {
                        habit in
                        habitContainer(habit)
                    }
                    .popover(isPresented: $detailsShown) {
                        HabitDetails(habit: $selectedHabit)
                    }
                }
            }
        } detail: {

        }
        // https://www.youtube.com/watch?v=RMCzFKAoap0
        .searchable(text: $searchText, placement: .automatic, prompt: "Habits, dates or more...")
        .onChange(of: searchText) {
            filteredList = habits.filter { $0.name.contains(searchText) }
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
    SearchView()
}
