//
//  Frequency.swift
//  Habrix
//
//  Created by Julian Schumacher on 03.10.25.
//

import Foundation

internal enum Frequency : String, RawRepresentable, Codable, CaseIterable, Identifiable, Hashable {
    var id: some Hashable { self }

//    static var allCases: [Frequency] = [.hourly, .daily, .weekly, . monthly, .yearly]

    case hourly
    case daily
    case weekly
    case monthly
    case yearly
    /// Custom with values month, week, days and hours
    //case custom(Int, Int, Int, Int)

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
