//
// Created by Yunarta Kartawahyudi on 5/10/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

public class VIPERViewContext {

    public internal (set) weak var controller: PlatformViewController?

    public init(controller: UIViewController?) {
        self.controller = controller
    }
}

public class VIPERField<T> {

    var observer: [(T) -> Void]? = [(T) -> Void]()

    public var value: T {
        didSet {
            observer?.forEach { closure in
                closure(value)
            }
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func onChange(_ closure: @escaping (T) -> Void) {
        observer?.append(closure)
        closure(value)
    }

    deinit {
        observer = nil
    }
}

public class VIPEROptionalField<T> {

    var observer: [(T) -> Void]? = [(T) -> Void]()

    var nilObserver: [() -> Void]? = [() -> Void]()

    public var value: T? {
        didSet {
            if let value = value {
                observer?.forEach { closure in
                    closure(value)
                }
            } else {
                nilObserver?.forEach { closure in
                    closure()
                }
            }

        }
    }

    public init(_ value: T?) {
        self.value = value
    }

    public func onChange(next: @escaping (T) -> Void, nullified: (() -> Void)? = nil) {
        observer?.append(next)
        if let nullified = nullified {
            nilObserver?.append(nullified)
        }

        if let value = value {
            next(value)
        } else {
            nullified?()
        }
    }

    deinit {
        observer = nil
        nilObserver = nil
    }
}

/** Class that where all the view interface of VIPER View will need to conform to.
 */
public protocol VIPERViewInterface: class {


}

private var keyVIPERViewContext = "keyVIPERViewContext"

extension VIPERViewInterface {

    var viewContext: VIPERViewContext? {
        get {
            return objc_getAssociatedObject(self, &keyVIPERViewContext) as? VIPERViewContext
        }

        set(value) {
            objc_setAssociatedObject(self, &keyVIPERViewContext, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

open class VIPERViewBinding: NSObject {

    @IBOutlet public private (set) weak var controller: PlatformViewController?

    private(set) var viewContext: VIPERViewContext?

    private weak var view: VIPERViewInterface?

    public init(view: VIPERViewInterface) {
        super.init()
        self.view = view
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        assert(view != nil)
        assert(controller != nil, "controller binding is required")

        self.viewContext = VIPERViewContext(controller: controller)
        self.view?.viewContext = self.viewContext
    }
}
