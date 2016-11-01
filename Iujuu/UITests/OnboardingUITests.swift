//
//  OnboardingUITests.swift
//  Iujuu
//
//  Created by user on 10/13/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import XCTest

class OnboardingUITests: IujuuBaseUITest {

    func testGoThroughAllThePages() {
        let collectionViewsQuery = app.collectionViews
        let image = collectionViewsQuery.cells.otherElements.children(matching: .image).element(boundBy: 0)
        image.swipeLeft()
        image.swipeLeft()
        image.swipeRight()
        image.swipeLeft()
        image.swipeLeft()
        collectionViewsQuery.buttons["Entendido"].tap()
        XCTAssert(app.buttons["Crear cuenta IUJUU"].exists)
        XCTAssert(app.buttons["Ya tengo una cuenta"].exists)
    }

    func testSkipOnboarding() {
        app.buttons["Saltar"].tap()
        XCTAssert(app.buttons["Crear cuenta IUJUU"].exists)
        XCTAssert(app.buttons["Ya tengo una cuenta"].exists)
    }

    func testRegisterCorrectly() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()
        
        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Tester")
        
        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("tester")
        
        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("tester@tester.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Tester123")
        app.toolbars.buttons["Done"].tap()
        tablesQuery.buttons["Registrarme"].press(forDuration: 0.5);

        XCTAssert(app.buttons["Nuevo regalo"].exists)
    }

    func testRegisterUserAlreadyExists() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("ErrorUser")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("ErrorUser")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("errorUser@errorUser.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("ErrorUser123")
        app.toolbars.buttons["Done"].tap()
        tablesQuery.buttons["Registrarme"].press(forDuration: 0.5);

        XCTAssert(app.alerts["Error"].exists)
    }

    func testRegisterUserNoName() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test@test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled )
    }

    func testRegisterUserNoSurname() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test@test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testRegisterUserNoEmail() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled )
    }

    func testRegisterUserWrongEmailFormatNoDot() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test@test")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled )
    }

    func testRegisterUserWrongEmailFormatNoAt() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test2test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testRegisterUserNoPassword() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test@test.com")

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testRegisterUserWrongPasswordNoCapital() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test2test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("test123")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testRegisterUserWrongPasswordNoNumber() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test2test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("TestTest")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testRegisterUserWrongPasswordLessThan6() {
        app.buttons["Saltar"].tap()
        app.buttons["Crear cuenta IUJUU"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Nombre").children(matching: .textField).element
        textField.tap()
        textField.typeText("Test")

        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Apellido").children(matching: .textField).element
        textField2.tap()
        textField2.typeText("Test")

        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField3.tap()
        textField3.typeText("test2test.com")
        tablesQuery.secureTextFields["Contraseña"].tap()
        tablesQuery.cells.containing(.button, identifier:"visibility").children(matching: .secureTextField).element.typeText("Tes1")
        app.toolbars.buttons["Done"].tap()

        XCTAssertFalse(app.buttons["Registrarme"].isEnabled)
    }

    func testLoginCorrectly() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()
        
        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("test@test.com")
        
        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Test123")
        tablesQuery.buttons["Ingresar"].tap()

        XCTAssert(app.buttons["Nuevo regalo"].exists)
    }

    func testLoginWrongUser() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("error@error.com")

        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Error123")
        tablesQuery.buttons["Ingresar"].tap()

        XCTAssert(app.alerts["Error"].exists)
    }

    func testLoginNoUsername() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables

        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Test123")

        XCTAssertFalse(tablesQuery.buttons["Ingresar"].isEnabled)
    }

    func testLoginWrongUsernameNoDot() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("test@testcom")

        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Test123")

        XCTAssertFalse(tablesQuery.buttons["Ingresar"].isEnabled)
    }

    func testLoginWrongUsernameNoAt() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("test2testcom")

        let secureTextField = tablesQuery.cells.containing(.staticText, identifier:"Contraseña").children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("Test123")

        XCTAssertFalse(tablesQuery.buttons["Ingresar"].isEnabled)
    }

    func testLoginNoPassword() {
        app.buttons["Saltar"].tap()
        app.buttons["Ya tengo una cuenta"].tap()

        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Correo Electrónico").children(matching: .textField).element
        textField.tap()
        textField.typeText("test@test.com")

        XCTAssertFalse(tablesQuery.buttons["Ingresar"].isEnabled)
    }


}
