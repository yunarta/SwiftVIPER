//
// Created by Yunarta Kartawahyudi on 5/11/17.
//

import Foundation

func validateBindings(_ bindings: [VIPERViewBindingOutlet]?) -> Bool {
    if let bindings = (bindings as NSArray?) {
        for binding in bindings {
            guard binding is VIPERViewBindingInterface else {
                return false
            }
        }
    }

    return true
}

private var keyPlatformViewControllerBindings = "keyPlatformViewControllerBindings"

extension PlatformViewController {

    func setupBindings(_ bindings: [VIPERViewBindingOutlet]?) {
        assert(validateBindings(bindings), "All binding must conform to VIPERViewBindingInterface")
        bindings?.forEach { binding in
            binding.controller = self
        }
    }

    public func dispatchViewDidLoad() {
        bindings?.forEach { binding in
            binding.viewDidLoad()
        }
    }

    public func dispatchViewWillAppear() {
        bindings?.forEach { binding in
            binding.viewWillAppear()
        }
    }

    public func dispatchViewDidAppear() {
        bindings?.forEach { binding in
            binding.viewDidAppear()
        }
    }

    public func dispatchViewWillLayout() {
        bindings?.forEach { binding in
            binding.viewWillLayout()
        }
    }

    public func dispatchViewDidLayout() {
        bindings?.forEach { binding in
            binding.viewDidLayout()
        }
    }

    public func dispatchViewWillDisappear() {
        bindings?.forEach { binding in
            binding.viewWillDisappear()
        }
    }

    public func dispatchViewDidDisappear() {
        bindings?.forEach { binding in
            binding.viewDidDisappear()
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
