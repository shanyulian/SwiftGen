//
//  CoreDataTests.swift
//  SwiftGenKit UnitTests
//
//  Created by David Jennes on 19/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import XCTest
import SwiftGenKit

class CoreDataTests: XCTestCase {
  func test() throws {
    let parser = CoreDataParser()

    try parser.parse(path: Fixtures.path(for: "Complex.xcdatamodeld", sub: .coreData))
  }
}
