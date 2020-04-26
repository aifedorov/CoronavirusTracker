//
//  TrendHelper.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

final class TrendHelper {

    private enum Constants {
        static let errorTitle = "⚠️"
    }

    /// Return 📈 or 📉 depend of daily cases or ⚠️ if wrong data
    static func calculateTrend(_ history: HistoryData?, _ stats: CountryStats?) -> String {
        guard
            let stats = stats,
            let history = history
        else {
            return Constants.errorTitle
        }

        if
            let yesterdayDate = DateHelper.dayBeforToday(count: 1),
            let dayBeforYesterdayDate = DateHelper.dayBeforToday(count: 2) {

            let yesterdayDateString = DateHelper.dateString(date: yesterdayDate)
            let dayBeforYesterdayDateString = DateHelper.dateString(date: dayBeforYesterdayDate)

            guard
                let yesterdayCountCases = history.timeline.cases[yesterdayDateString],
                let dayBeforYesterdayCountCases = history.timeline.cases[dayBeforYesterdayDateString]
                else {
                    return Constants.errorTitle
            }

            let yesterdayCases = yesterdayCountCases - dayBeforYesterdayCountCases
            let todayCases = stats.todayCases

            if todayCases > yesterdayCases {
                return "📈"
            } else {
                return "📉"
            }
        } else {
            return Constants.errorTitle
        }
    }
}
