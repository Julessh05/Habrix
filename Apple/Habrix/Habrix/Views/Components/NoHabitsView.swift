//
//  NoHabitsView.swift
//  Habrix
//
//  Created by Julian Schumacher on 21.10.25.
//

import SwiftUI

internal struct NoHabitsView: View {

    @State private var addShown : Bool = false

    var body: some View {
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
                .popover(isPresented: $addShown) {
                    EditHabit()
                }
                .padding(12)
                .foregroundStyle(.white)
                .glassEffect(.regular.tint(.blue))
            }
            .frame(width: 200, height: 400)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .glassEffect(.regular.interactive())
    }
}

#Preview {
    NoHabitsView()
}
