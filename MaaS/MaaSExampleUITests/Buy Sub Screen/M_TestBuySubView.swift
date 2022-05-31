//
//  M_TestBuySubView.swift
//  MaaSExampleUITests
//
//  Created by Слава Платонов on 31.05.2022.
//

import XCTest

class M_TestBuySubView: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_openWebLink() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        app.cells.staticTexts["Мини"].tap()
        app.buttons["Оплатить 1999 ₽"].tap()
        app.buttons["Привязать карту"].tap()
        sleep(2)
    }
    
    func test_correctViewLabels() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        app.cells.staticTexts["Мини"].tap()
        app.buttons["Оплатить 1999 ₽"].tap()
        XCTAssert(app.buttons["Привязать карту"].exists)
        XCTAssert(app.staticTexts["Оплатите подписку"].exists)
        XCTAssert(app.staticTexts["После этого подписка привяжется к вашей карте. Поменять привязку можно позже в настройках"].exists)
    }
}
