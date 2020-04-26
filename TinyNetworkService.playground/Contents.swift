import Foundation
import XCTest

struct Resource<T> {
    let url: URL
    let parser: (Data) -> T?
}

struct CountryStats: Codable {
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
}

final class WebService {
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            if let data = data {
                completion(resource.parser(data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}


final class Tests: XCTestCase {

    private var webservice: WebService!

    override func setUp() {
        super.setUp()
        webservice = WebService()
    }

    override func tearDown() {
        webservice = nil
        super.tearDown()
    }

    func testCountryStatsRequest() {
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

Tests.defaultTestSuite.run()
