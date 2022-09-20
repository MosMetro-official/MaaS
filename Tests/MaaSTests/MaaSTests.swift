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
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testActiveSubFlow() {
        let active = sut.showActiveFlow()
        XCTAssertNotNil(active)
    }
    
    func testChooseSubFlow() {
        let choose = sut.showChooseFlow()
        XCTAssertNotNil(choose)
    }
}
