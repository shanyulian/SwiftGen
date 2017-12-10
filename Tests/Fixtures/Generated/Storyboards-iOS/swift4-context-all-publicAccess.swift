// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import CustomSegue
import LocationPicker
import SlackTextViewController

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

public protocol StoryboardType {
  static var storyboardName: String { get }
}

public extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

public struct SceneType<T: Any> {
  public let storyboard: StoryboardType.Type
  public let identifier: String

  public func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

public struct InitialSceneType<T: Any> {
  public let storyboard: StoryboardType.Type

  public func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

public protocol SegueType: RawRepresentable { }

public extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
public enum StoryboardScene {
  public enum AdditionalImport: StoryboardType {
    public static let storyboardName = "AdditionalImport"

    public static let initialScene = InitialSceneType<LocationPicker.LocationPickerViewController>(storyboard: AdditionalImport.self)

    public static let `public` = SceneType<SlackTextViewController.SLKTextViewController>(storyboard: AdditionalImport.self, identifier: "public")
  }
  public enum Anonymous: StoryboardType {
    public static let storyboardName = "Anonymous"

    public static let initialScene = InitialSceneType<UINavigationController>(storyboard: Anonymous.self)
  }
  public enum Dependency: StoryboardType {
    public static let storyboardName = "Dependency"

    public static let dependent = SceneType<UIViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  public enum Message: StoryboardType {
    public static let storyboardName = "Message"

    public static let initialScene = InitialSceneType<UIViewController>(storyboard: Message.self)

    public static let composer = SceneType<UIViewController>(storyboard: Message.self, identifier: "Composer")

    public static let messagesList = SceneType<UITableViewController>(storyboard: Message.self, identifier: "MessagesList")

    public static let navCtrl = SceneType<UINavigationController>(storyboard: Message.self, identifier: "NavCtrl")

    public static let urlChooser = SceneType<XXPickerViewController>(storyboard: Message.self, identifier: "URLChooser")
  }
  public enum Placeholder: StoryboardType {
    public static let storyboardName = "Placeholder"

    public static let navigation = SceneType<UINavigationController>(storyboard: Placeholder.self, identifier: "Navigation")
  }
  public enum Wizard: StoryboardType {
    public static let storyboardName = "Wizard"

    public static let initialScene = InitialSceneType<CreateAccViewController>(storyboard: Wizard.self)

    public static let acceptCGU = SceneType<UIViewController>(storyboard: Wizard.self, identifier: "Accept-CGU")

    public static let createAccount = SceneType<CreateAccViewController>(storyboard: Wizard.self, identifier: "CreateAccount")

    public static let preferences = SceneType<UITableViewController>(storyboard: Wizard.self, identifier: "Preferences")

    public static let validatePassword = SceneType<UIViewController>(storyboard: Wizard.self, identifier: "Validate_Password")
  }
}

public extension CreateAccViewController {
  public enum StoryboardSegue: String {
    case showPassword = "ShowPassword"
  }

  func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  public enum TypedStoryboardSegue {
    case showPassword(destination: UIViewController)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: UIStoryboardSegue) {
      switch segue.identifier ?? "" {
      case "ShowPassword":
        let vc = segue.destination
        self = .showPassword(destination: vc)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in CreateAccViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

public extension XXPickerViewController {
  public enum StoryboardSegue: String {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }

  func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  public enum TypedStoryboardSegue {
    case customBack(destination: UIViewController, segue: CustomSegueClass2)
    case embed(destination: UIViewController)
    case nonCustom(destination: UIViewController)
    case showNavCtrl(destination: UINavigationController, segue: CustomSegueClass)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: UIStoryboardSegue) {
      switch segue.identifier ?? "" {
      case "CustomBack":
        guard let segue = segue as? CustomSegueClass2 else {
          fatalError("Segue 'CustomBack' is not of the expected type CustomSegueClass2.")
        }
        let vc = segue.destination
        self = .customBack(destination: vc, segue: segue)
      case "Embed":
        let vc = segue.destination
        self = .embed(destination: vc)
      case "NonCustom":
        let vc = segue.destination
        self = .nonCustom(destination: vc)
      case "Show-NavCtrl":
        guard let segue = segue as? CustomSegueClass else {
          fatalError("Segue 'Show-NavCtrl' is not of the expected type CustomSegueClass.")
        }
        guard let vc = segue.destination as? UINavigationController else {
          fatalError("Destination of segue 'Show-NavCtrl' is not of the expected type UINavigationController.")
        }
        self = .showNavCtrl(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in XXPickerViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

public extension LocationPicker.LocationPickerViewController {
  public enum StoryboardSegue: String {
    case `private`
  }

  func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  public enum TypedStoryboardSegue {
    case `private`(destination: SlackTextViewController.SLKTextViewController, segue: CustomSegue.SlideDownSegue)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: UIStoryboardSegue) {
      switch segue.identifier ?? "" {
      case "private":
        guard let segue = segue as? CustomSegue.SlideDownSegue else {
          fatalError("Segue 'private' is not of the expected type CustomSegue.SlideDownSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'private' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`private`(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in LocationPicker.LocationPickerViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

public extension SlackTextViewController.SLKTextViewController {
  public enum StoryboardSegue: String {
    case `private`
  }

  func perform(segue: StoryboardSegue, sender: Any? = nil) {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }

  public enum TypedStoryboardSegue {
    case `private`(destination: SlackTextViewController.SLKTextViewController, segue: CustomSegue.SlideDownSegue)
    case unnamedSegue

    // swiftlint:disable cyclomatic_complexity
    init(segue: UIStoryboardSegue) {
      switch segue.identifier ?? "" {
      case "private":
        guard let segue = segue as? CustomSegue.SlideDownSegue else {
          fatalError("Segue 'private' is not of the expected type CustomSegue.SlideDownSegue.")
        }
        guard let vc = segue.destination as? SlackTextViewController.SLKTextViewController else {
          fatalError("Destination of segue 'private' is not of the expected type SlackTextViewController.SLKTextViewController.")
        }
        self = .`private`(destination: vc, segue: segue)
      case "":
        self = .unnamedSegue
      default:
        fatalError("Unrecognized segue '\(segue.identifier ?? "")' in SlackTextViewController.SLKTextViewController")
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}

public enum StoryboardSegue {
  public enum AdditionalImport: String, SegueType {
    case `private`
  }
  public enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }
  public enum Wizard: String, SegueType {
    case showPassword = "ShowPassword"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
