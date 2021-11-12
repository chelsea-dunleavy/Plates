//
//  PlatesTests.swift
//  PlatesTests
//
//  Created by Shyam Kumar on 9/9/21.
//

import XCTest
@testable import Plates

class PlatesTests: XCTestCase {
    func testPlateCalc() {
        let model = PlateTableViewModel(weight: 172.5)
        print(model.plates)
    }
}
