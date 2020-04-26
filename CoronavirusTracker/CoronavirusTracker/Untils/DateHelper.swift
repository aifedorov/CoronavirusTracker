//
//  DateHelper.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

final class DateHelper {
    
    private static let dateFormatter = DateFormatter()

    static func dayBeforToday(count: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.setValue(-count, for: .day)

        let today = Date()
        return Calendar.current.date(byAdding: dateComponents, to: today)
    }

    static func date(dateString: String) -> Date? {
        guard !dateString.isEmpty else { return nil }
        DateHelper.dateFormatter.dateFormat = "M/dd/yy"
        return DateHelper.dateFormatter.date(from: dateString)
    }

    static func dateString(date: Date) -> String {
        DateHelper.dateFormatter.dateFormat = "M/dd/yy"
        return DateHelper.dateFormatter.string(from: date)
    }
}
