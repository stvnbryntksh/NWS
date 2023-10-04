import XCTest
@testable import NationalWeatherService

final class NationalWeatherServiceTests: XCTestCase {
    func testCurrentConditions() throws {
        let expectation = self.expectation(description: "Get current weather at location.")
//        nws.currentCondition(latitude: 47.6174, longitude: -122.2017) { result in
        nws.currentCondition(latitude: 37.7749, longitude: -122.4194) { result in
            XCTAssertSuccess(result)
            let period = try! result.get()
//            print("PERIOD ------- ", period.name as Any, period.conditions, period.relativeHumidity?.normal as Any, period.dewPoint?.measurement?.value as Any, period.probabilityOfPrecipitation?.normal as Any)
            //,period.apparentTemperature)//, "wetBulbGlobeTemperatureUnit", period.wetBulbGlobeTemperature)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 60)
    }

    static var allTests = [
        ("testCurrentConditions", testCurrentConditions)
    ]
}
