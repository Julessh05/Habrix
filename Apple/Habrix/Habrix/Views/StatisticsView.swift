//
//  StatisticsView.swift
//  Habrix
//
//  Created by Julian Schumacher on 21.10.25.
//

import SwiftUI
import SwiftData

#warning("Using mock data in statistics view")
struct StatisticsView: View {

    @Query private var habits : [Habit]

    @State private var statistics : Statistics? = nil

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading) {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<20) {
                                index in
                                VStack {
                                    Image(systemName: "flame")
                                        .foregroundStyle(index % 2 == 1 ? .orange : .primary)
                                    Text(String(index + 1))
                                        .font(.caption)
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                } header: {
                    HStack {
                        headerText("Streak")
                        Spacer()
                        Text("\(statistics?.currentStreak ?? 0) \(statistics?.currentStreak == 1 ? "Day" : "Days")")
                            .font(.subheadline)
                            .padding(.top, 8)
                    }
                } footer: {
                    footerText("Keep on working!")
                }
                Divider()
                Section {
                    ProgressView(
                        value: Double(statistics?.habitsCompletedToday ?? 0),
                        total: Double(statistics?.totalHabits ?? 0)
                    )
                    .progressViewStyle(.linear)
                    .padding(.vertical, 4)
                } header: {
                    HStack {
                        headerText("Today")
                        Spacer()
                        Text(
                            "\(String(Int(statistics?.habitsCompletedToday ?? 0)))/\(String(Int(statistics?.totalHabits ?? 0)))"
                        )
                            .font(.subheadline)
                            .padding(.top, 8)
                    }
                } footer: {
                    footerText("Today's total completage progress")
                }
                Divider()
                Section {
                    // TODO: insert last month view
                } header: {
                    headerText("Last month")
                } footer: {
                    footerText("Percentage completion of all your habits this month")
                }
                //                .padding(.top, 16)
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .navigationTitle("Statistics")
#if os(iOS)
            .navigationBarTitleDisplayMode(.automatic)
            .onAppear {
                statistics = StatisticsHelper.getStatistics(habits: habits)
            }
#endif
        } detail: {

        }
    }

    @ViewBuilder
    private func headerText(_ text : String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.top, 8)
    }

    @ViewBuilder
    private func footerText(_ text : String) -> some View {
        Text(text)
            .font(.footnote)
            .padding(.bottom, 8)
    }
}

#Preview {
    StatisticsView()
}
