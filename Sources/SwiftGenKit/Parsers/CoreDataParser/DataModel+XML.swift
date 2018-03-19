//
//  DataModel+XML.swift
//  SwiftGenKit
//
//  Created by David Jennes on 19/03/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna
import PathKit

extension Kanna.XMLElement {
  func parseInt(_ attr: String) -> Int? {
    guard let value = self[attr] else { return nil }
    return Int(value)
  }

  func parseBool(_ attr: String) -> Bool {
    let value = self[attr] ?? ""
    return value == "YES"
  }
}

extension DataModel.Attribute {
  enum XML {
    static let nameAttribute = "name"
    static let typeAttribute = "attributeType"
    static let customClassAttribute = "customClassName"
    static let optionalAttribute = "optional"
    static let scalarAttribute = "usesScalarValueType"
  }

  init(with object: Kanna.XMLElement) {
    name = object[XML.nameAttribute] ?? ""
    type = object[XML.typeAttribute] ?? ""
    customClass = object[XML.customClassAttribute] ?? ""
    isOptional = object.parseBool(XML.optionalAttribute)
    isScalar = object.parseBool(XML.scalarAttribute)
    userInfo = DataModel.loadUserInfo(from: object)
  }
}

extension DataModel.FetchedProperty {
  enum XML {
    static let requestXPath = "fetchRequest"
    static let nameAttribute = "name"
    static let predicateAttribute = "predicateString"
    static let entityAttribute = "entity"
  }

  convenience init(with object: Kanna.XMLElement) {
    let request = object.at_xpath(XML.requestXPath)
    self.init(
      name: object[XML.nameAttribute] ?? "",
      predicate: request?[XML.predicateAttribute] ?? "",
      entity: request?[XML.entityAttribute] ?? "",
      userInfo: DataModel.loadUserInfo(from: object)
    )
  }
}

extension DataModel.Relationship {
  enum XML {
    static let nameAttribute = "name"
    static let inverseNameAttribute = "inverseName"
    static let customClassAttribute = "customClassName"
    static let optionalAttribute = "optional"
    static let orderedAttribute = "ordered"
    static let toManyAttribute = "toMany"
    static let destinationAttribute = "destinationEntity"
  }

  convenience init(with object: Kanna.XMLElement) {
    self.init(
      name: object[XML.nameAttribute] ?? "",
      inverseName: object[XML.inverseNameAttribute] ?? "",
      isOptional: object.parseBool(XML.optionalAttribute),
      isOrdered: object.parseBool(XML.orderedAttribute),
      toMany: object.parseBool(XML.toManyAttribute),
      destination: object[XML.destinationAttribute] ?? "",
      userInfo: DataModel.loadUserInfo(from: object)
    )
  }
}

extension DataModel.Entity {
  enum XML {
    static let attributeXPath = "attribute"
    static let fetchedPropertyXPath = "fetchedProperty"
    static let relationshipXPath = "relationship"

    static let nameAttribute = "name"
    static let classNameAttribute = "representedClassName"
    static let isAbstractAttribute = "isAbstract"
    static let parentAttribute = "parentEntity"
  }

  convenience init(with object: Kanna.XMLElement) {
    self.init(
      name: object[XML.nameAttribute] ?? "",
      className: object[XML.classNameAttribute] ?? "",
      isAbstract: object.parseBool(XML.isAbstractAttribute),
      parent: object[XML.parentAttribute],
      attributes: object.xpath(XML.attributeXPath).map(DataModel.Attribute.init),
      fetchedProperties: object.xpath(XML.fetchedPropertyXPath).map(DataModel.FetchedProperty.init),
      relationships: object.xpath(XML.relationshipXPath).map(DataModel.Relationship.init),
      userInfo: DataModel.loadUserInfo(from: object)
    )
  }
}

extension DataModel {
  enum XML {
    static let entityXPath = "/model/entity"
    static let userInfoXPath = "userInfo/entry"
  }

  convenience init(name: String, document: Kanna.XMLDocument) {
    let entities = document.xpath(XML.entityXPath).map {
      DataModel.Entity(with: $0)
    }
    self.init(name: name, entities: entities)

    entities.forEach { $0.model = self }
  }

  fileprivate static func loadUserInfo(from object: Kanna.XMLElement) -> [String: String] {
    return Dictionary(uniqueKeysWithValues: object.xpath(XML.userInfoXPath).map {
      ($0["key"] ?? "", $0["value"] ?? "")
    })
  }
}
