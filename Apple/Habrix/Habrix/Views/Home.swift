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

    @State private var searchText : String = ""

    var body: some View {
        // https://nilcoalescing.com/blog/SwiftUISearchEnhancementsIniOSAndiPadOS26/
        TabView {
            Tab("Timeline", systemImage: "clock") {
                HabitsTimelineView()
            }
            Tab("Statistics", systemImage: "chart.bar") {
                StatisticsView()
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
        .searchable(text: $searchText, placement: .automatic, prompt: "Habits, dates or more...")
#if os(iOS)
        .searchDictationBehavior(.inline(activation: .onSelect))
        .tabBarMinimizeBehavior(.onScrollDown)
        .navigationTitle("Habits")
        .navigationBarTitleDisplayMode(.automatic)
#endif
        .tabViewSearchActivation(.searchTabSelection)
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    }
}

#Preview {
    Home()
        .modelContainer(for: Habit.self, inMemory: true)
}
