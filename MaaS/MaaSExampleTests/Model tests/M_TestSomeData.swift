//
//  MaaSExampleTests.swift
//  MaaSExampleTests
//
//  Created by Слава Платонов on 30.05.2022.
//

import XCTest
@testable import MaaS

class M_TestSomeData: XCTestCase {
    
    var sub: Subscription!
    var subs: [Subscription]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sub = getSub()
        subs = getSubs()
    }

    override func tearDownWithError() throws {
        sub = nil
        subs = nil
        try super.tearDownWithError()
    }
    
    private func getSub() -> Subscription {
        return Subscription(
            title: "Мини",
            price: "1999 ₽",
            tariffs: [
                SubTariffs(
                    title: "Такси",
                    trasnportTariff: "10 поездок",
                    transportImage: UIImage.getAssetImage(image: "taxi")
                ),
                SubTariffs(
                    title: "Общественный транспорт",
                    trasnportTariff: "Безлимит",
                    transportImage: UIImage.getAssetImage(image: "transport")
                ),
                SubTariffs(
                    title: "Велобайк",
                    trasnportTariff: "15 поездок в день до 30 минут",
                    transportImage: UIImage.getAssetImage(image: "transport")
                )
            ]
        )
    }
    
    private func getSubs() -> [Subscription] {
        return Subscription.getSubscriptions()
    }

    func test_checkFakeSubscriptionsCount() {
        let totalCountOfSubs = subs.count
        XCTAssertEqual(totalCountOfSubs, 3)
    }
    
    func test_propertiesOfSubscription() {
        XCTAssertEqual(sub.title, "Мини")
        XCTAssertEqual(sub.price, "1999 ₽")
    }
    
    func test_SubTariffs() {
        let firstTariff = sub.tariffs[0]
        let secondTariff = sub.tariffs[1]
        let thirdTariff = sub.tariffs[2]
        XCTAssertEqual(firstTariff.title, "Такси")
        XCTAssertEqual(firstTariff.trasnportTariff, "10 поездок")
        XCTAssertEqual(secondTariff.title, "Общественный транспорт")
        XCTAssertEqual(secondTariff.trasnportTariff, "Безлимит")
        XCTAssertEqual(thirdTariff.title, "Велобайк")
        XCTAssertEqual(thirdTariff.trasnportTariff, "15 поездок в день до 30 минут")
    }
    
    func test_SubNotEqualToNil() {
        XCTAssertNotNil(sub)
    }
}
