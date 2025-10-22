//
//  KeyValueStorage.swift
//  Habrix
//
//  Created by Julian Schumacher on 22.10.25.
//

import Foundation

internal struct KeyValueStorage {

    private static var sharedInstance : NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default

    private static let currentStreakKey = "currentStreak"

    internal static func getCurrentStreak() -> Int {
        Int(sharedInstance.longLong(forKey: currentStreakKey))
    }
}
