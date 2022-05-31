//
//  M_TestChooseSubView.swift
//  MaaSExampleUITests
//
//  Created by Слава Платонов on 31.05.2022.
//

import XCTest

class M_TestChooseSubView: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_buttonTitlesOnChooseScreen() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        app.cells.staticTexts["Мини"].tap()
        XCTAssertEqual(app.buttons["Оплатить 1999 ₽"].label, "Оплатить 1999 ₽")
        app.cells.staticTexts["Стандарт"].tap()
        XCTAssertEqual(app.buttons["Оплатить 2999 ₽"].label, "Оплатить 2999 ₽")
        app.cells.staticTexts["Макси"].tap()
        XCTAssertEqual(app.buttons["Оплатить 2999 ₽"].label, "Оплатить 2999 ₽")
        app.swipeUp()
        app.tables.staticTexts["Собрать свой тариф"].tap()
        XCTAssertEqual(app.buttons["Продолжить"].label, "Продолжить")
    }
    
    func test_tapOnMirButton() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        sleep(2)
        app.buttons["mir"].tap()
    }
    
    func test_correctViewLabels() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        sleep(2)
        XCTAssert(app.staticTexts["МультиТранспорт"].exists)
        XCTAssert(app.staticTexts["Выберите подписку"].exists)
    }
}
