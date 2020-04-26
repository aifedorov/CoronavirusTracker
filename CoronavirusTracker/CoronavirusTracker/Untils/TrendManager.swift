//
//  TrendManager.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

final class TrendHelper {
    /// Return 📈 or 📉 depend of daily cases or ⚠️ if wrong data
    func calculateTrend(_ history: HistoryData?, _ stats: CountryStats?) -> String {
        guard
            let stats = stats,
            let history = history
        else {
            return "⚠️"
        }

        if
            let yesterdayDate = dayBeforToday(count: 1),
            let dayBeforYesterdayDate = dayBeforToday(count: 2) {

            let yesterdayDateString = AppDelegate.dateFormatter.string(from: yesterdayDate)
            let dayBeforYesterdayDateString = AppDelegate.dateFormatter.string(from: dayBeforYesterdayDate)

            guard
                let yesterdayCountCases = history.timeline.cases[yesterdayDateString],
                let dayBeforYesterdayCountCases = history.timeline.cases[dayBeforYesterdayDateString]
                else {
                    return Constants.errorTitle
            }

            let yesterdayCases = yesterdayCountCases - dayBeforYesterdayCountCases
            let todayCases = stats.todayCases

            if todayCases > yesterdayCases {
                return "📈\(stats.todayCases)🦠\(stats.cases)💀\(stats.deaths)"
            } else {
                return "📉\(stats.todayCases)🦠\(stats.cases)💀\(stats.deaths)"
            }
        } else {
            return "🦠\(stats.cases)💀\(stats.deaths)"
        }
    }

    private func dayBeforToday(count: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.setValue(-count, for: .day)

        let today = Date()
        return Calendar.current.date(byAdding: dateComponents, to: today)
    }

}
