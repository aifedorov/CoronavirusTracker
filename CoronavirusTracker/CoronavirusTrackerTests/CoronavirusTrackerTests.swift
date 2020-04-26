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

    private var webservice: WebService!

    override func setUpWithError() throws {
        webservice = WebService()
    }

    override func tearDownWithError() throws {
       webservice = nil
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
}
