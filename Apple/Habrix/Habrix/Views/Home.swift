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

internal struct Home: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var habits: [Habit]

    @State private var addShown : Bool = false

    @State private var selectedHabit : Habit? = nil

    @State private var detailsShown : Bool = false

    @State private var searchText : String = ""

    var body: some View {
        // https://nilcoalescing.com/blog/SwiftUISearchEnhancementsIniOSAndiPadOS26/
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
        .searchable(text: $searchText, placement: .automatic, prompt: "Habits, dates or more...")
        .searchDictationBehavior(.inline(activation: .onSelect))
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
            HabitOverview(
                habits: habits,
                selectedHabit: $selectedHabit,
                detailsShown: $detailsShown
            )
        }
    }

    @ViewBuilder
    private func timelineView() -> some View {
        if habits.isEmpty {
            emptyView()
        } else {
            TimelineView(
                habits: habits,
                selectedHabit: $selectedHabit,
                detailsShown: $detailsShown
            )
        }
    }

    @ViewBuilder
    private func calendarView() -> some View {
        if habits.isEmpty {
            emptyView()
        } else {
            CalendarView()
        }
    }
}

#Preview {
    Home()
        .modelContainer(for: Habit.self, inMemory: true)
}
