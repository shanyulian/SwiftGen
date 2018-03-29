//
//  Config.swift
//  swiftgen
//
//  Created by Olivier Halligon on 01/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit
import Yams

// MARK: - Config

struct Config {
  enum Keys {
    static let inputDir = "input_dir"
    static let outputDir = "output_dir"
  }

  let inputDir: Path?
  let outputDir: Path?
  let commands: [String: [Config.Entry]]
}

extension Config {
  init(file: Path) throws {
    if !file.exists {
      throw Config.Error.pathNotFound(path: file)
    }
    let content: String = try file.read()
    let anyConfig = try Yams.load(yaml: content)
    guard let config = anyConfig as? [String: Any] else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: anyConfig))
    }
    self.inputDir = (config[Keys.inputDir] as? String).map { Path($0) }
    self.outputDir = (config[Keys.outputDir] as? String).map { Path($0) }
    var cmds: [String: [Config.Entry]] = [:]
    for parserCmd in allParserCommands {
      if let cmdEntry = config[parserCmd.name] {
        do {
          cmds[parserCmd.name] = try Config.Entry.parseCommandEntry(yaml: cmdEntry)
        } catch let e as Config.Error {
          // Prefix the name of the command for a better error message
          throw e.withKeyPrefixed(by: parserCmd.name)
        }
      }
    }
    self.commands = cmds
  }
}

// MARK: - Linting

extension Config {
  func lint(logger: (LogLevel, String) -> Void = logMessage) {
    logger(.info, "> Common parent directory used for all input paths:  \(self.inputDir ?? "<none>")")
    logger(.info, "> Common parent directory used for all output paths: \(self.outputDir ?? "<none>")")
    for (cmd, entries) in self.commands {
      let entriesCount = "\(entries.count) " + (entries.count > 1 ? "entries" : "entry")
      logger(.info, "> \(entriesCount) for command \(cmd):")
      for var entry in entries {
          entry.makeRelativeTo(inputDir: self.inputDir, outputDir: self.outputDir)
          for inputPath in entry.paths where inputPath.isAbsolute {
            logger(.warning, "\(cmd).paths: \(inputPath) is an absolute path.")
          }
          if case TemplateRef.path(let tp) = entry.template, tp.isAbsolute {
            logger(.warning, "\(cmd).templatePath: \(tp) is an absolute path.")
          }
          if entry.output.isAbsolute {
            logger(.warning, "\(cmd).output: \(entry.output) is an absolute path.")
          }
          logger(.info, "  $ " + entry.commandLine(forCommand: cmd))
      }
    }
  }
}

// MARK: - Config.Error

extension Config {
  enum Error: Swift.Error, CustomStringConvertible {
    case missingEntry(key: String)
    case wrongType(key: String?, expected: String, got: Any.Type)
    case pathNotFound(path: Path)

    var description: String {
      switch self {
      case let .missingEntry(key):
        return "Missing entry for key \(key)."
      case let .wrongType(key, expected, got):
        return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)."
      case let .pathNotFound(path):
        return "File \(path) not found."
      }
    }

    func withKeyPrefixed(by prefix: String) -> Config.Error {
      switch self {
      case let .missingEntry(key):
        return Config.Error.missingEntry(key: "\(prefix).\(key)")
      case let .wrongType(key, expected, got):
        let fullKey = [prefix, key].flatMap({ $0 }).joined(separator: ".")
        return Config.Error.wrongType(key: fullKey, expected: expected, got: got)
      default:
        return self
      }
    }
  }
}
