//
//  Frequency.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import Foundation

/// THe Frequency a habit should renew
internal enum Frequency : String, RawRepresentable, Codable, CaseIterable, Identifiable, Hashable {
    var id: some Hashable { self }

//    static var allCases: [Frequency] = [.hourly, .daily, .weekly, . monthly, .yearly]

    /// Renews every hour of a day
    case hourly
    /// Renews daily
    case daily
    /// Renews weekly, so every 7 days
    case weekly
    /// Renews montly, for internal purpose, this is 28 days
    case monthly
    /// Renews yearly, so  every365 days
    case yearly
    /// Custom with values month, week, days and hours
    //case custom(Int, Int, Int, Int)

    /// Returns the components for a calender that should be shown to
    /// represent this frequency appropriate
    /// - Returns: The components to include
    internal func getCalendarComponent() -> Calendar.Component {
        switch self {
        case .hourly:
            return .hour
        case .daily:
            return .day
        case .weekly:
            return .weekOfYear
        case .monthly:
            return .month
        case .yearly:
            return .year
        }
    }
}
