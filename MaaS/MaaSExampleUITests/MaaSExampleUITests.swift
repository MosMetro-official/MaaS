//
//  MaaSExampleUITests.swift
//  MaaSExampleUITests
//
//  Created by Слава Платонов on 31.05.2022.
//

import XCTest

class MaaSExampleUITests: XCTestCase {

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
        app.tables.staticTexts["Мини"].tap()
        XCTAssertEqual(app.buttons["Оплатить 1999 ₽"].label, "Оплатить 1999 ₽")
        app.tables.staticTexts["Стандарт"].tap()
        XCTAssertEqual(app.buttons["Оплатить 2999 ₽"].label, "Оплатить 2999 ₽")
        app.tables.staticTexts["Макси"].tap()
        XCTAssertEqual(app.buttons["Оплатить 2999 ₽"].label, "Оплатить 2999 ₽")
        app.swipeUp()
        app.tables.staticTexts["Собрать свой тариф"].tap()
        XCTAssertEqual(app.buttons["Продолжить"].label, "Продолжить")
    }

    func test_OpenLinkToBuySubscription() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Попробовать еще раз"].tap()
        app.tables.staticTexts["10 поездок"].tap()
        app.staticTexts["Оплатить 1999 ₽"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.0);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        app.buttons["Привязать карту"].tap()
        app.swipeUp()
        app.swipeUp()
        app.swipeDown()
        app.buttons["Готово"].tap()
    }
}
