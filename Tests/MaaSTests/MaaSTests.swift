import XCTest
import CoreAnalytics
@testable import MaaS

final class MaaSTests: XCTestCase {
    
    var sut: MaaS!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let manager: _AnalyticsManager = AnalyticsManager(engines: [])
        sut = MaaS(analyticsManager: manager)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
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
