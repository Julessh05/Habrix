//
//  SearchView.swift
//  Habrix
//
//  Created by Julian Schumacher on 14.10.25.
//

import SwiftUI

struct SearchView: View {

    @State private var searchValue : String = ""

    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    NavigationLink("Today") {

                    }
                    NavigationLink("Ending soon") {

                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.automatic)
        } detail: {

        }
    }
}

#Preview {
    SearchView()
}
