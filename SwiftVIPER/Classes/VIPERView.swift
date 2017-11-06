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

public typealias VIPERViewBindingOutlet = VIPERViewBinding & VIPERViewBindingInterface

@objc public protocol VIPERViewBindingInterface: class {

    init()
}

open class VIPERViewBinding: NSObject {

    public internal (set) weak var controller: PlatformViewController? {
        didSet {
            self.viewContext = VIPERViewContext(controller: controller)
        }
    }

    public internal (set) var viewContext: VIPERViewContext?

    weak var internalView: VIPERViewInterface?

    public init(view: VIPERViewInterface) {
        super.init()
        self.internalView = view
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        assert(internalView != nil)
    }

    open func viewDidLoad() {
        assert(controller != nil, "This view binding is not connected to controls bindings outlet")

        self.internalView?.viewContext = self.viewContext
    }

    open func viewWillAppear() {

    }

    open func viewDidAppear() {

    }

    open func viewWillLayout() {

    }

    open func viewDidLayout() {

    }

    open func viewWillDisappear() {

    }

    open func viewDidDisappear() {

    }
}
