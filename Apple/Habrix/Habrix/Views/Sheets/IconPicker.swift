//
//  IconPicker.swift
//  Habrix
//
//  Created by Julian Schumacher on 02.10.25.
//

import SwiftUI

internal struct IconPicker: View {

    @Environment(\.dismiss) private var dismiss

    @Binding internal var iconName : String

    private let icons: [String] = [
        "figure.walk",
        "figure.walk.motion",
        "figure.run",
        "figure.american.football",
        "figure.archery",
        "figure.australian.football",
        "figure.badminton",
        "figure.barre",
        "figure.baseball",
        "figure.basketball",
        "figure.bowling",
        "figure.boxing",
        "figure.climbing",
        "figure.cooldown",
        "figure.core.training",
        "figure.cricket",
        "figure.cross.training",
        "figure.dance",
        "figure.disc.sports",
        "figure.skiing.downhill",
        "figure.elliptical",
        "figure.equestrian.sports",
        "figure.fencing",
        "figure.fishing",
        "figure.strengthtraining.functional",
        "figure.golf",
        "figure.gymnastics",
        "figure.hand.cycling",
        "figure.handball",
        "figure.highintensity.intervaltraining",
        "figure.hiking",
        "figure.hockey",
        "figure.field.hockey",
        "figure.ice.hockey",
        "figure.hunting",
        "figure.indoor.cycle",
        "figure.jumprope",
        "figure.kickboxing",
        "figure.lacrosse",
        "figure.martial.arts",
        "figure.mind.and.body",
        "figure.mixed.cardio",
        "figure.open.water.swim",
        "figure.outdoor.cycle",
        "figure.pickleball",
        "figure.pilates",
        "figure.play",
        "figure.pool.swim",
        "figure.racquetball",
        "figure.rolling",
        "figure.indoor.rowing",
        "figure.outdoor.rowing",
        "figure.rugby",
        "figure.sailing",
        "figure.skateboarding",
        "figure.ice.skating",
        "figure.snowboarding",
        "figure.indoor.soccer",
        "figure.outdoor.soccer",
        "figure.socialdance",
        "figure.softball",
        "figure.squash",
        "figure.stair.stepper",
        "figure.stairs",
        "figure.step.training"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) {
                    ForEach(icons, id: \.self) {
                        icon in
                        Button {
                            iconName = icon
                            dismiss()
                        } label: {
                            Image(systemName: icon)
                                .renderingMode(.original)
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .scaledToFit()
                                .padding(16)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .padding(.top, 16)
            #if os(iOS)
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.automatic)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {

    @Previewable @State var iconName: String = "plus"

    IconPicker(iconName: $iconName)
}
