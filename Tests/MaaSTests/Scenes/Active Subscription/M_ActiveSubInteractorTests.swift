//
//  M_ActiveSubInteractorTests.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import XCTest
@testable import MaaS

final class M_ActiveSubInteractorTests: XCTestCase {
    
    // TODO: возможно нужен воркер чтобы замокать запросы в сеть
    
    var sut: M_ActiveSubInteractor!
    var presenter: M_ActiveSubPresenterMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        presenter = M_ActiveSubPresenterMock()
        sut = M_ActiveSubInteractor(presenter: presenter)
    }

    override func tearDownWithError() throws {
        presenter = nil
        sut = nil
        try super.tearDownWithError()
    }
    
//    func testInteractorFetchUserInfo() {
//        sut.fetchUserInfo()
//        XCTAssertTrue(presenter.isCalledPrepareResult, "Not started prepare result state")
//    }
//
//    func testInteractorFetchSupportUrl() {
//        sut.fetchSupportUrl()
//        XCTAssertTrue(presenter.isCalledPrepareSupport, "Not started prepare support state")
//    }
//
//    func testInteractorCheckCardUpdates() {
//        sut.checkCardUpdates()
//        XCTAssertTrue(presenter.isCalledPrepareResult, "Not started prepare card update state")
//    }
}
