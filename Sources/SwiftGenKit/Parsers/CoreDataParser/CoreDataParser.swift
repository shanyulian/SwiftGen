//
//  CoreDataParser.swift
//  SwiftGenKit
//
//  Created by David Jennes on 18/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna
import PathKit

public enum CoreDataParserError: Error, CustomStringConvertible {
  case invalidFile(path: Path, reason: String)
  case unsupportedFileType(path: Path)
  case invalidVersionInfo(path: Path)

  public var description: String {
    switch self {
    case .invalidFile(let path, let reason):
      return "error: Unable to parse file at \(path). \(reason)"
    case .unsupportedFileType(let path):
      return "error: Unsupported file type for \(path)."
    case .invalidVersionInfo(let path):
      return "error: Invalid model version info at \(path)."
    }
  }
}

private enum CoreData {
  static let modelExtension = "xcdatamodeld"
  static let currentVersionFile = ".xccurrentversion"
  static let currentVersionKey = "_XCCurrentVersionName"
  static let modelFile = "contents"
}

public final class CoreDataParser: Parser {
  var models = [DataModel]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    if path.extension == CoreData.modelExtension {
      try addModel(at: path)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

      for file in dirChildren where file.extension == CoreData.modelExtension {
        try addModel(at: file)
      }
    }
  }

  func addModel(at path: Path) throws {
    let modelPath = try getVersion(for: path)

    let document: Kanna.XMLDocument
    do {
      document = try Kanna.XML(xml: modelPath.read(), encoding: .utf8)
    } catch let error {
      throw CoreDataParserError.invalidFile(path: modelPath, reason: "XML parser error: \(error).")
    }

    models += [DataModel(name: path.lastComponentWithoutExtension,
                         document: document)]
  }

  private func getVersion(for path: Path) throws -> Path {
    guard path.extension == CoreData.modelExtension else {
      throw CoreDataParserError.unsupportedFileType(path: path)
    }

    let versionPath = path + CoreData.currentVersionFile
    guard let info = NSDictionary(contentsOf: versionPath.url),
      let current = info[CoreData.currentVersionKey] as? String else {
      throw CoreDataParserError.invalidVersionInfo(path: versionPath)
    }

    return path + current + CoreData.modelFile
  }
}
