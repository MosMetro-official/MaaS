//
//  M_TestUserSub.swift
//  MaaS
//
//  Created by Слава Платонов on 30.05.2022.
//

import XCTest
@testable import MaaS

class M_TestUserSub: XCTestCase {
    
    var userSub: UserSubscription!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userSub = getUserSub()
    }

    override func tearDownWithError() throws {
        userSub = nil
        try super.tearDownWithError()
    }
    
    private func getUserSub() -> UserSubscription {
        return UserSubscription.getUserSubscription()
    }
    
    func test_checkFakeTariffsCount() {
        let totalCountOfTariffs = userSub.tariffs.count
        XCTAssertEqual(totalCountOfTariffs, 2)
    }

    func test_UserSubProperties() {
        XCTAssertEqual(userSub.active, "Активна до 22 марта 2022")
        XCTAssertEqual(userSub.cardNumber, "МИР •••• 2267")
    }
    
    func test_UserSubTariffs() {
        let firstTariff = userSub.tariffs[0]
        let secondTariff = userSub.tariffs[1]
        XCTAssertEqual(firstTariff.title, "Такси")
        XCTAssertNil(firstTariff.type)
        XCTAssertEqual(firstTariff.leftTripCount, 2)
        XCTAssertEqual(firstTariff.totalTripCount, 10)
        XCTAssertEqual(secondTariff.title, "Общественный транспорт")
        XCTAssertEqual(secondTariff.type, "Безлимит")
        XCTAssertNil(secondTariff.leftTripCount)
        XCTAssertNil(secondTariff.totalTripCount)
    }
    
    func test_UserSubNotEqualToNil() {
        XCTAssertNotNil(userSub)
    }
}
