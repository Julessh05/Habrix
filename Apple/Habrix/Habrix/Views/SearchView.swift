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
        VStack {
            TextField("Search something...", text: $searchValue)
                .textFieldStyle(.roundedBorder)
                .padding(16)
            List {
                
            }
        }
    }
}

#Preview {
    SearchView()
}
