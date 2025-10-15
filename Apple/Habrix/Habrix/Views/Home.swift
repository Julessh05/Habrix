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
            TabView {
                Tab("Overview", systemImage: "list.bullet") {
                    habitOverview()
                }
                Tab("Timeline", systemImage: "clock") {
                    timelineView()
                }
                Tab("Calendar", systemImage: "calendar") {
                    calendarView()
                }
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewSearchActivation(.searchTabSelection)
            .popover(isPresented: $addShown) {
                EditHabit()
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
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addShown.toggle()
                    } label: {
                        Label("Add habit", systemImage: "plus")
                    }
                }
            }
            .popover(isPresented: $detailsShown) {
                HabitDetails(habit: $selectedHabit)
            }
        } detail: {
            // TODO: add detail view for iPad and mac
            Text("Select an item")
        }
    }

    @ViewBuilder
    private func emptyView() -> some View {
        VStack {
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
        }
    }

    @ViewBuilder
    private func habitOverview() -> some View {
        if habits.isEmpty {
            emptyView()
        } else {
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
        }
    }

    @ViewBuilder
    private func timelineView() -> some View {
        if habits.isEmpty {
            emptyView()
        } else {
            List {
            }
        }
    }

    @ViewBuilder
    private func calendarView() -> some View {
        if habits.isEmpty {
            emptyView()
        } else {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], pinnedViews: .sectionHeaders) {

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

    @ViewBuilder
    private func habitExecutionContianer(_ habit : Habit) -> some View {
        Button {

        } label: {
            HStack {
            }
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
}

#Preview {
    Home()
        .modelContainer(for: Habit.self, inMemory: true)
}
