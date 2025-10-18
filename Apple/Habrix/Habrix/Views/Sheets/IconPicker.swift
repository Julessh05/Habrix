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

    @State private var icons : [String : [String]] = [:]

    @State private var errLoadingIconsShown : Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) {
                    ForEach(Array(icons.keys).sorted(), id: \.self) {
                        iconCategory in
                        Section {
                            ForEach(Array(icons[iconCategory]!), id: \.self) {
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
                        } header: {
                            HStack {
                                Text(iconCategory.capitalized)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 15)
                                Spacer()
                            }
                        }
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
            .onAppear {
                loadIcons()
            }
            .alert("Loading error", isPresented: $errLoadingIconsShown) {
                Button("Retry") { loadIcons() }
            } message: {
                Text("There's been an error loading the icons from disk")
            }
        }
    }

    private func loadIcons() {
        do {
            let path = Bundle.main.path(forResource: "icons", ofType: "json")
            let data = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .topLevelDictionaryAssumed) as! [String : [String]]
            for iconCategory in json.keys {
                if !icons.keys.contains(iconCategory) {
                    icons[iconCategory] = []
                }
                for icon in json[iconCategory]! {
                    icons[iconCategory]!.append(icon)
                }
            }
        } catch {
            errLoadingIconsShown.toggle()
        }
    }
}

#Preview {

    @Previewable @State var iconName: String = "plus"

    IconPicker(iconName: $iconName)
}
