//
//  M_ActiveSubControllerTests.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import XCTest
import CoreAnalytics
@testable import MaaS

final class M_ActiveSubControllerTests: XCTestCase {
    
    var sut: M_ActiveSubController!
    var interactor: M_ActiveSubInteractorMock!
    var window: UIWindow!
    var analyticsManager: _AnalyticsManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        interactor = M_ActiveSubInteractorMock()
        analyticsManager = AnalyticsManager(engines: [])
        sut = M_ActiveSubController(analyticsManager: analyticsManager)
        sut.interactor = interactor
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    override func tearDownWithError() throws {
        analyticsManager = nil
        interactor = nil
        sut = nil
        window = nil
        try super.tearDownWithError()
    }
    
    func testActiveSubControllerFetchUserInfo() {
        sut.viewDidLoad()
        XCTAssertTrue(interactor.isCalledFetchUser, "Not started request user info")
    }
}
