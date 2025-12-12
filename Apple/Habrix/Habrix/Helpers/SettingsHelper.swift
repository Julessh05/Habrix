//
//  SettingsHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 09.10.25.
//

import Foundation

/// Helper class for all settings related actions
internal class SettingsHelper {

    /// The identifier for the app version text in the settings pane
    private static let appVersion : String = "app_version_preference"

    /// Identifier for the build version text in the settings pane
    private static let buildVersion : String = "build_version_preference"

    /// Loads all the settings from the budle and updates values in the settings pane
    internal static func loadSettings() -> Void {
        updateValues()
    }

    /// updates the values for app version and build version with the values of the app bundle
    private static func updateValues() -> Void {
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleShortVersionString"], forKey: appVersion)
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleVersion"], forKey: buildVersion)
    }
}
