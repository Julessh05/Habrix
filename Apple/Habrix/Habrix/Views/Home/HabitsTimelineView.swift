//
//  HabitsTimelineView.swift
//  Habrix
//
//  Created as TimelineView by Julian Schumacher on 17.10.25.
//
//  Renamed to HabitsTimelineView by Julian Schumacher on 22.10.25.
//

import SwiftUI
import SwiftData

struct HabitsTimelineView: View {

    @Query private var habitExecutions : [HabitExecution]

    @State private var selectedHabit : Habit?

    @State private var detailsShown : Bool = false

    @State private var addShown : Bool = false

    var body: some View {
        NavigationSplitView {
            if habitExecutions.isEmpty {
                NoHabitsView()
                    .navigationTitle("Timeline")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.automatic)
#endif
            } else {
                buildHabitsTimeline()
                    .popover(isPresented: $detailsShown) {
                        HabitDetails(habit: $selectedHabit)
                    }
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                addShown.toggle()
                            } label: {
                                Label("Add habit", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $addShown) {
                        EditHabit()
                    }
                    .navigationTitle("Timeline")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.automatic)
#endif
            }
        } detail: {

        }
    }

    @ViewBuilder
    private func buildHabitsTimeline() -> some View {
        let days = sortExecutionsIntoDays()
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .center, spacing: 8) {
                    ForEach(Array(days.keys).sorted(), id: \.self) {
                        day in
                        Section {
                            ForEach(Array(days[day]!).sorted(by: { $0.timestamp < $1.timestamp }), id: \.self) {
                                execution in
                                habitExecutionContainer(execution)
                                    .id(execution.timestamp)
                            }
                        } header: {
                            HStack {
                                Text(day, style: .date)
                                    .font(.headline)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                                Spacer()
                            }
                            .id(day)
                        } footer: {
                            Divider()
                        }
                    }
                }
                .padding(.vertical, 32)
            }
            .onAppear {
                let midnightToday = Calendar.current.startOfDay(for: Date.now)
                let todaysExecutions : [HabitExecution]  = days[midnightToday] ?? []
                let nextExecution : HabitExecution? = todaysExecutions.first(where: { $0.timestamp > Date.now })
                // Scroll to today
                DispatchQueue.main.async {
                    proxy.scrollTo(
                        nextExecution?.timestamp ?? Date.now,
                        anchor: .top
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func habitExecutionContainer(_ execution : HabitExecution) -> some View {
        HStack {
            Button {
                selectedHabit = execution.habit
                detailsShown.toggle()
            } label: {
                HStack {
                    Image(systemName: execution.habit?.iconName ?? "questionmark")
                    Text(execution.habit?.name ?? "Unknown")
                    Spacer()
                    Text(execution.timestamp.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }
            Button {
                execution.isCompleted.toggle()
            } label: {
                Image(systemName: execution.isCompleted ? "checkmark.circle" : "circle")
            }
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, minHeight: 30, idealHeight: 40, maxHeight: 75)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .glassEffect(.regular.tint(execution.timestamp < Date.now ? .secondary.opacity(0.3) : .clear))
        .padding(.horizontal, 32)
    }

    private func sortExecutionsIntoDays() -> [Date : [HabitExecution]] {
        return Dictionary(grouping: habitExecutions, by: { Calendar.current.startOfDay(for: $0.timestamp)
        })
    }
}

#Preview {
    HabitsTimelineView()
        .modelContainer(for: Habit.self, inMemory: true)
}
