//
//  Category.swift
//  Habrix
//
//  Created by Julian Schumacher on 06.10.25.
//

import Foundation
import SwiftData

/// A single category a habit can be mapped to
@Model
internal class Category {

    /// The name of the category. This will be visible to the user
    @Attribute(.allowsCloudEncryption) internal var name : String = "CATEGORY DEFAULT NAME"

    /// A static object to represents the empty category.
    /// All habits without a category are mapped to this habit
    internal static var empty : Category  = Category(name: "EMPTY")

    /// The list of all habits that are part of this category
    internal var habits : [Habit]? = []

    internal init(name : String) {
        self.name = name
    }
}
