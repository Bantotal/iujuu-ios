//
//  IujuuBaseUITest.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import XCTest

class IujuuBaseUITest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = [TestArguments.mockData]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

}
