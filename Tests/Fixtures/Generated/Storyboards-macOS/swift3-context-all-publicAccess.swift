// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import Cocoa
import FadeSegue
import PrefsWindowController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: NSStoryboard {
    return NSStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }
}

public struct SceneType<T: Any> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateController(withIdentifier: identifier) as? T else {
      fatalError("Controller '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

public struct InitialSceneType<T: Any> {
  public let storyboard: StoryboardType.Type

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialController() as? T else {
      fatalError("Controller is not of the expected class \(T.self).")
    }
    return controller
  }
}

public protocol SegueType: RawRepresentable { }

public extension NSSeguePerforming {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue?(withIdentifier: segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let `private` = SceneType<PrefsWindowController.DBPrefsWindowController>(storyboard: AdditionalImport.self, identifier: "private")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let dependent = SceneType<NSViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let messageDetails = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageDetails")

    public static let messageList = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageList")

    public static let messageListFooter = SceneType<NSViewController>(storyboard: Message.self, identifier: "MessageListFooter")

    public static let messagesTab = SceneType<CustomTabViewController>(storyboard: Message.self, identifier: "MessagesTab")

    public static let splitMessages = SceneType<NSSplitViewController>(storyboard: Message.self, identifier: "SplitMessages")

    public static let windowCtrl = SceneType<NSWindowController>(storyboard: Message.self, identifier: "WindowCtrl")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let dependent = SceneType<NSControllerPlaceholder>(storyboard: Placeholder.self, identifier: "Dependent")

    public static let window = SceneType<NSWindowController>(storyboard: Placeholder.self, identifier: "Window")
  }
}

public extension CustomTabViewController {
  public enum StoryboardSegue: String {
    case embed = "Embed"
    case modal = "Modal"
    case popover = "Popover"
    case sheet = "Sheet"
    case show = "Show"
    case `public`
  }

  func perform(segue: StoryboardSegue, sender: Any? = nil) {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }

  public enum TypedStoryboardSegue {
    case embed(destination: NSViewController)
    case modal(destination: NSViewController)
    case popover(destination: NSViewController)
    case sheet(destination: NSViewController)
    case show(destination: NSViewController)
    case `public`(destination: NSViewController, segue: FadeSegue.SlowFadeSegue)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: NSStoryboardSegue) {
      switch segue.identifier ?? "" {
      case "Embed":
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'Embed' is not of the expected type NSViewController.")
        }
        self = .embed(destination: vc)
      case "Modal":
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'Modal' is not of the expected type NSViewController.")
        }
        self = .modal(destination: vc)
      case "Popover":
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'Popover' is not of the expected type NSViewController.")
        }
        self = .popover(destination: vc)
      case "Sheet":
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'Sheet' is not of the expected type NSViewController.")
        }
        self = .sheet(destination: vc)
      case "Show":
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'Show' is not of the expected type NSViewController.")
        }
        self = .show(destination: vc)
      case "public":
        guard let segue = segue as? FadeSegue.SlowFadeSegue else {
          fatalError("Segue 'public' is not of the expected type FadeSegue.SlowFadeSegue.")
        }
        guard let vc = segue.destinationController as? NSViewController else {
          fatalError("Destination of segue 'public' is not of the expected type NSViewController.")
        }
        self = .`public`(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in CustomTabViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

public enum StoryboardSegue {
  public enum Message: String, SegueType {
    case embed = "Embed"
    case modal = "Modal"
    case popover = "Popover"
    case sheet = "Sheet"
    case show = "Show"
    case `public`
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
