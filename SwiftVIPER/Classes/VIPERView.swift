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
public typealias VIPERViewBindingOutlet = VIPERViewBinding

@objc public protocol VIPERViewBindingInterface: class {

    init()
}

enum VIPERViewBindingState {
    case none
    case viewDidLoad
    case viewWillAppear
    case viewDidAppear
    case viewWillLayout
    case viewDidLayout
    case viewWillDisappear
    case viewDidDisappear
}

open class VIPERViewBinding: NSObject {

    public internal (set) weak var controller: PlatformViewController? {
        didSet {
            self.viewContext = VIPERViewContext(controller: controller)
        }
    }

    public internal (set) var viewContext: VIPERViewContext?


    var state: VIPERViewBindingState = .none
    
    public override init() {
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    open func viewDidLoad() {
        assert(controller != nil, "This view binding is not connected to controls bindings outlet")
        state = .viewDidLoad
    }

    open func viewWillAppear() {
        state = .viewWillAppear
    }

    open func viewDidAppear() {
        state = .viewDidAppear
    }

    open func viewWillLayout() {
        state = .viewWillLayout
    }

    open func viewDidLayout() {
        state = .viewDidLayout
    }

    open func viewWillDisappear() {
        state = .viewWillDisappear
    }

    open func viewDidDisappear() {
        state = .viewDidDisappear
    }
}
