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

    @State private var searchValue : String = ""

    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    NavigationLink("Today") {

                    }
                    NavigationLink("Ending soon") {

                    }
                    if !habits.isEmpty {
                        NavigationLink("All habits") {
                            HabitOverview()
                        }
                    } else {
                        Text("Add your first habit to see more options")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Discover")
#if os(iOS)
            .navigationBarTitleDisplayMode(.automatic)
#endif
        } detail: {

        }
    }
}

#Preview {
    SearchView()
}
