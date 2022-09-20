import XCTest
import CoreAnalytics
@testable import MaaS

final class MaaSTests: XCTestCase {
    
    var sut: MaaS!
    
    override func setUp() {
        super.setUp()
        let manager: _AnalyticsManager = AnalyticsManager(engines: [])
        sut = MaaS(analyticsManager: manager)
    }
    func testExample() throws {
        let test = "Hello, World!"
        XCTAssertEqual(test, "Hello, World!")
    }
}
