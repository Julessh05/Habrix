//
//  SettingsHelper.swift
//  Habrix
//
//  Created by Julian Schumacher on 09.10.25.
//

import Foundation

internal class SettingsHelper {

    private static let appVersion = "app_version_preference"

    private static let buildVersion = "build_version_preference"

    internal static func loadSettings() -> Void {
        updateValues()
    }

    private static func updateValues() -> Void {
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleShortVersionString"], forKey: appVersion)
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleVersion"], forKey: buildVersion)
    }
}
