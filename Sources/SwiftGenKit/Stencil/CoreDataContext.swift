//
//  CoreDataContext.swift
//  SwiftGenKit
//
//  Created by David Jennes on 20/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

extension CoreDataParser {
  public func stencilContext() -> [String: Any] {
    return [
      "models": models
    ]
  }
}
