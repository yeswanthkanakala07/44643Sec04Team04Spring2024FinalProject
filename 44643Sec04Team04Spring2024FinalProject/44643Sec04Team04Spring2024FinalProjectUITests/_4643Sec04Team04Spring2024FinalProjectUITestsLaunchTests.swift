//
//  _4643Sec04Team04Spring2024FinalProjectUITestsLaunchTests.swift
//  44643Sec04Team04Spring2024FinalProjectUITests
//
//  Created by Yaswanth Kanakala on 2/19/24.
//

import XCTest

final class _4643Sec04Team04Spring2024FinalProjectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
