//
// Created by Yunarta Kartawahyudi on 5/11/17.
//

import Foundation

func validateBindings(_ bindings: [VIPERViewBindingOutlet]?) -> Any? {
    if let bindings = (bindings as NSArray?) {
        for binding in bindings {
            guard binding is VIPERViewBindingInterface else {
                return binding
            }
        }
    }

    return nil
}

private var keyPlatformViewControllerBindings = "keyPlatformViewControllerBindings"

extension PlatformViewController {

    func setupBindings(_ bindings: [VIPERViewBindingOutlet]?) {
//        assert(validateBindings(bindings) == nil,
//            "All binding must conform to VIPERViewBindingInterface, \(type(of: validateBindings(bindings))) is not")
        bindings?.forEach { binding in
            binding.controller = self
        }
    }

    public func dispatchViewDidLoad() {
        bindings?.forEach { binding in
            binding.viewDidLoad()
            assert(binding.state == .viewDidLoad, "\(type(of: binding)) super.viewDidLoad() chain is not called")
        }
    }

    public func dispatchViewWillAppear() {
        bindings?.forEach { binding in
            binding.viewWillAppear()
            assert(binding.state == .viewWillAppear, "super.viewWillAppear() chain is not called")
        }
    }

    public func dispatchViewDidAppear() {
        bindings?.forEach { binding in
            binding.viewDidAppear()
            assert(binding.state == .viewDidAppear, "\(type(of: binding)) super.viewDidAppear() chain is not called")
        }
    }

    public func dispatchViewWillLayout() {
        bindings?.forEach { binding in
            binding.viewWillLayout()
            assert(binding.state == .viewWillLayout, "\(type(of: binding)) super.viewWillLayout() chain is not called")
        }
    }

    public func dispatchViewDidLayout() {
        bindings?.forEach { binding in
            binding.viewDidLayout()
            assert(binding.state == .viewDidLayout, "\(type(of: binding)) super.viewDidLayout() chain is not called")
        }
    }

    public func dispatchViewWillDisappear() {
        bindings?.forEach { binding in
            binding.viewWillDisappear()
            assert(binding.state == .viewWillDisappear, "\(type(of: binding)) super.viewWillDisappear() chain is not called")
        }
    }

    public func dispatchViewDidDisappear() {
        bindings?.forEach { binding in
            binding.viewDidDisappear()
            assert(binding.state == .viewDidDisappear, "\(type(of: binding)) super.viewDidDisappear() chain is not called")
        }
    }
}

#if os(macOS)

extension NSViewController {

    @objc @IBOutlet public var bindings: [VIPERViewBindingOutlet]? {
        get {
            return objc_getAssociatedObject(self, &keyPlatformViewControllerBindings) as? [VIPERViewBindingOutlet]
        }

        set(bindings) {
            setupBindings(bindings)
            objc_setAssociatedObject(self, &keyPlatformViewControllerBindings, bindings, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

#else

extension UIViewController {

    @objc @IBOutlet public var bindings: [VIPERViewBindingOutlet]? {
        get {
            return objc_getAssociatedObject(self, &keyPlatformViewControllerBindings) as? [VIPERViewBindingOutlet]
        }

        set(bindings) {
            setupBindings(bindings)
            objc_setAssociatedObject(self, &keyPlatformViewControllerBindings, bindings, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

#endif
