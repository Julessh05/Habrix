//
//  CalendarView.swift
//  Habrix
//
//  Created by Julian Schumacher on 17.10.25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationSplitView {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], pinnedViews: .sectionHeaders) {

            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.automatic)
        } detail: {

        }
    }
}

#Preview {
    CalendarView()
}
