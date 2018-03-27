//
//  CoreDataTests.swift
//  SwiftGenKit UnitTests
//
//  Created by David Jennes on 19/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import StencilSwiftKit
import SwiftGenKit
import XCTest

class CoreDataTests: XCTestCase {
  func test() throws {
    let parser = CoreDataParser()

    try parser.parse(path: Fixtures.path(for: "Complex.xcdatamodeld", sub: .coreData))

    let templateString = """
    {% macro describeEntity entity %}
      {{ entity.name }}: {{ entity.parent.name }}
    {% endmacro %}

    {% for model in models %}
      # {{ model.name }}

      {% for name,entity in model.entities %}
      {% call describeEntity entity %}
      {% endfor %}
    {% endfor %}
    """
    let template = StencilSwiftTemplate(templateString: templateString,
                                        environment: stencilSwiftEnvironment())
    let result: String
    do {
      result = try template.render(parser.stencilContext())
      print(result)
    } catch let error {
      fatalError("Unable to render template: \(error)")
    }
  }
}
