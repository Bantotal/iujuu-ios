//
//  HomeUITests.swift
//  Iujuu
//
//  Created by user on 10/13/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import XCTest

class HomeUITests: IujuuBaseUITest {

    func login(user: String = "test") {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("\(user)@\(user).com")

        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Test123")
        tablesQuery.buttons["Ingresar"].tap()
    }

    func testGoToSettings() {
        login()
        app.images["SettingsButton"].tap()
        XCTAssert(app.navigationBars["Ajustes"].exists)
    }

    func testAddRegaloWithCodigoIncorrectCode() {
        login()
        app.buttons["Nuevo regalo"].tap()
        app.sheets.buttons["Ingresar código de regalo"].tap()
        XCTAssert(app.navigationBars["Iujuu_Staging.RSInsertCodeView"].exists)

        let codigoDeRegaloTextField = app.textFields["Código de regalo"]
        codigoDeRegaloTextField.tap()
        codigoDeRegaloTextField.typeText("AAABB")
        app.navigationBars["Iujuu_Staging.RSInsertCodeView"].buttons["Siguiente"].tap()
        XCTAssert(app.alerts["Error"].exists)
    }

    func testAddRegaloWithCorrectCode() {
        login()
        app.buttons["Nuevo regalo"].tap()
        app.sheets.buttons["Ingresar código de regalo"].tap()
        XCTAssert(app.navigationBars["Iujuu_Staging.RSInsertCodeView"].exists)

        let codigoDeRegaloTextField = app.textFields["Código de regalo"]
        codigoDeRegaloTextField.tap()
        codigoDeRegaloTextField.typeText("AAAAA")
        app.navigationBars["Iujuu_Staging.RSInsertCodeView"].buttons["Siguiente"].tap()
        XCTAssert(app.buttons["Participar del regalo"].exists)
    }

    func testParticiparRegalo() {
        login()

        let regaloTitle = "Cumpleaños de Valentina"
        app.tables.cells.staticTexts[regaloTitle].tap()
        XCTAssert(app.navigationBars["Regalo"].exists)

        app.buttons["Participar"].tap()
        XCTAssert(app.navigationBars["Participar"].exists)

        let tablesQuery = app.tables

        XCTAssertFalse(app.buttons["Pagar con galicia"].isEnabled)
        let textRow = tablesQuery.cells.containing(.staticText, identifier:"Deja tu mensaje...").element
        textRow.tap()
        let textView = textRow.children(matching: .textView).element
        textView.typeText("Hola")

        let importeRow = tablesQuery.cells["ImporteCell"]
        importeRow.tap()
        app.textFields["ImporteInput"].typeText("3456")
        XCTAssertTrue(app.buttons["Pagar con galicia"].isEnabled)

        app.buttons["Pagar con galicia"].tap()
    }

    func testVotarRegalo() {
        login()

        let regaloTitle = "Cumpleaños de Valentina"
        let optionToVote = "Jean"
        app.tables.cells.staticTexts[regaloTitle].tap()
        XCTAssert(app.navigationBars["Regalo"].exists)
        app.tables.cells.staticTexts[optionToVote].tap()
        XCTAssertFalse(app.tables.cells.staticTexts[optionToVote].isSelected)
    }

}
