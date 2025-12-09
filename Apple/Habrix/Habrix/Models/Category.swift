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

    @Attribute(.allowsCloudEncryption) internal var name : String = "CATEGORY DEFAULT NAME"

    internal static var empty : Category  = Category(name: "EMPTY")

    internal var habits : [Habit]? = []

    internal init(name : String) {
        self.name = name
    }
}
