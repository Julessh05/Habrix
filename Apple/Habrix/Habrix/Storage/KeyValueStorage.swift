//
//  KeyValueStorage.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

/// Storage control class for the Key-Value Storage
internal struct KeyValueStorage {

    /// The default shared instance of this storage
    private static var sharedInstance : NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default

    /// The key for the current streak saved to the key-value store
    private static let currentStreakKey = "currentStreak"

    /// Loads the current streak from the default instance and returns it as a number of days as int
    ///- Returns: the streak as a number of days as Integer
    internal static func getCurrentStreak() -> Int {
        Int(sharedInstance.longLong(forKey: currentStreakKey))
    }
}
