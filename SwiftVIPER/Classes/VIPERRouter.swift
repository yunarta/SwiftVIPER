//
// Created by Yunarta Kartawahyudi on 4/10/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if os(macOS)
    typealias ViewController = NSViewController
#else
    typealias ViewController = UIViewController
#endif

public class Intent: NSObject {

    public var action: String?

    public var data: URL?

    public lazy var parameters = [AnyHashable: Any]()

    public internal(set) weak var sender: PlatformViewController?

    public init(action: String? = nil, data: URL? = nil) {
        self.action = action
        self.data = data
    }

    public convenience init(data: URL? = nil) {
        self.init(action: nil, data: data)
    }
}

extension ViewController {

    private static var keyForIntent = "keyVIPERRoutingInfo"

    /** With VIPER, a view controller created by routing may have an intent set to define its behavior.
     */
    public var intent: Intent? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.keyForIntent) as? Intent
        }

        set(value) {
            objc_setAssociatedObject(self, &UIViewController.keyForIntent, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public protocol VIPERRouter: class {

    /** Perform a routing intent, where the VIPERRouting will take action upon the intent.
     */
    func performRouting(_ intent: Intent)
}

extension ViewController: VIPERRouter {

    public var router: VIPERRouter {
        return self
    }

    public func performRouting(_ intent: Intent) {
        intent.sender = self
        recurseRouting(intent)
    }

    func recurseRouting(_ intent: Intent) {
        if !(routing?.willPerformRouting(self, intent: intent) ?? false) {
            // intent not consumed
            if let parent = parent {
                parent.recurseRouting(intent)
            }
        }
    }
}

@objc public protocol VIPERRouting {

    func willPerformRouting(_ controller: UIViewController, intent: Intent) -> Bool
}

extension ViewController {

    private static var keyForRouting = "keyForRouting"

    /** With VIPER, a view controller created by routing may have an intent set to define its behavior.
     */
    @IBOutlet public var routing: VIPERRouting? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.keyForRouting) as? VIPERRouting
        }

        set(value) {
            objc_setAssociatedObject(self, &UIViewController.keyForRouting, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
