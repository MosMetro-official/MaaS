//
//  M_ActiveSubPresenterTests.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import XCTest
@testable import MaaS

final class M_ActiveSubPresenterTests: XCTestCase {
    
    var sut: M_ActiveSubscriptionPresenter!
    var controller: M_ActiveSubControllerMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        controller = M_ActiveSubControllerMock()
        sut = M_ActiveSubPresenter(controller: controller)
    }

    override func tearDownWithError() throws {
        controller = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testActivePresenterPrepareErrorState() {
        let response = M_ActiveSubModels.Response.Error(title: "Error", descr: "Repeat please", isCardError: true)
        sut.prepareError(response)
        XCTAssertTrue(controller.isCalledDisplayUserInfo, "Not started show error state")
    }
    
    func testActivePresenterPrepareLoadingState() {
        let response = M_ActiveSubModels.Response.Loading(title: "Loading", descr: "Wait a little bit")
        sut.prepareLoading(response)
        XCTAssertTrue(controller.isCalledDisplayUserInfo, "Not started show loading state")
    }
    
    func testActivePresenterPrepareResultState() {
        let response = M_ActiveSubModels.Response.UserInfo()
        sut.prepareResultState(response)
        XCTAssertTrue(controller.isCalledDisplayUserInfo, "Not started show result state")
    }
    
    func testActivePresenterPrepareSupportForm() {
        let response = M_ActiveSubModels.Response.SupportForm(url: "www.test.url.com")
        sut.prepareSupportForm(response)
        XCTAssertTrue(controller.isCalledOpenSafari, "Not started show safari controller")
    }
    
    func testActivePresenterPrepare() {
        let notification = M_MaasDebtNotifification()
        let response = M_ActiveSubModels.Response.Debt(notification: notification)
        sut.prepareDebtNotifications(response)
        XCTAssertTrue(controller.isCalledShowDebtNotification, "Not started show debt notification")
    }
}
