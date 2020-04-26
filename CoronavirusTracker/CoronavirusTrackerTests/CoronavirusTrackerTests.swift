//
//  CoronavirusTrackerTests.swift
//  CoronavirusTrackerTests
//
//  Created by Александр Федоров on 25.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import CoronavirusTracker

final class CoronavirusTrackerTests: XCTestCase {

    private var webservice = WebService()
    private var dateFormatter = DateFormatter()

    override func setUpWithError() throws {
        webservice = WebService()

        dateFormatter.dateFormat = "M/dd/yy"
    }

    func testCountryStatsRequest() throws {
        let expectation = self.expectation(description: "load country stats")
        let url = URL(string: "https://corona.lmao.ninja/v2/countries/ru")!
        let resource = Resource<CountryStats>(url: url) { (data) -> CountryStats? in
            return try? JSONDecoder().decode(CountryStats.self, from: data)
        }
        let result = CountryStats(country: "Russia", cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0)
        var countryStats: CountryStats?

        webservice.load(resource) { stats in
            countryStats = stats
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(countryStats?.country, result.country)
    }

    func testParseDateString() {
        let date = dateFormatter.date(from: "4/25/20")!
        let result = DateHelper.dateString(date: date)

        XCTAssertEqual("4/25/20", result)
    }

    func testParseDate() {
        let date = dateFormatter.date(from: "4/25/20")

        let result = DateHelper.date(dateString: "4/25/20")
        XCTAssertEqual(date, result)
    }

    func testDayBeforeToday() {
        let yesterdayDateString = "4/25/20"
        let yesterdayDate = dateFormatter.date(from: yesterdayDateString)!
        let result = DateHelper.dayBeforToday(count: 1)!

        XCTAssertTrue(Calendar.current.isDate(yesterdayDate, equalTo: result, toGranularity: .day))
        XCTAssertTrue(Calendar.current.isDate(yesterdayDate, equalTo: result, toGranularity: .month))
        XCTAssertTrue(Calendar.current.isDate(yesterdayDate, equalTo: result, toGranularity: .year))
    }

    func testPositiveTrend() {
        let cases = [
            "4/24/20": 10,
            "4/25/20": 20]

        let timeline = HistoryData.Timeline(cases: cases,
                                            deaths: [:],
                                            recovered: [:])
        let history = HistoryData(country: "", timeline: timeline)
        let stats = CountryStats(country: "",
                                 cases: 0,
                                 todayCases: 15,
                                 deaths: 0,
                                 todayDeaths: 0,
                                 recovered: 0)

        let result = TrendHelper.calculateTrend(history, stats)

        XCTAssertEqual(result, "📈")
    }

    func testNegativeTrend() {
        let cases = [
            "4/24/20": 10,
            "4/25/20": 20]

        let timeline = HistoryData.Timeline(cases: cases,
                                            deaths: [:],
                                            recovered: [:])
        let history = HistoryData(country: "", timeline: timeline)
        let stats = CountryStats(country: "",
                                 cases: 0,
                                 todayCases: 5,
                                 deaths: 0,
                                 todayDeaths: 0,
                                 recovered: 0)

        let result = TrendHelper.calculateTrend(history, stats)

        XCTAssertEqual(result, "📉")
    }
}
