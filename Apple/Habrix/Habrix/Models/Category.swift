//
//  Category.swift
//  Habrix
//
//  Created by Julian Schumacher on 06.10.25.
//

import Foundation
import SwiftData

@Model
internal class Category {

    @Attribute(.unique, .allowsCloudEncryption) internal var name : String

    internal static var empty : Category  = Category(name: "EMPTY")

    internal init(name : String) {
        self.name = name
    }
}
