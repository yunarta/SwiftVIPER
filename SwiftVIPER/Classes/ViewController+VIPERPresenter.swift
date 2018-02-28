//
// Created by Yunarta Kartawahyudi on 5/11/17.
//

import Foundation

extension PlatformViewController {

}

public class Presenters {
 
    var presenters = [String: VIPERPresenter]()
    
    public func set(name: String, _ presenter: VIPERPresenter) {
        self.presenters[name] = presenter
    }
    
    public func get(name: String) -> VIPERPresenter? {
        return self.presenters[name]
    }
}

private var keyPlatformViewControllerPresenters = "keyPlatformViewControllerPresenters"

extension PlatformViewController {

    public var presenters: Presenters {
        let object = objc_getAssociatedObject(self, &keyPlatformViewControllerPresenters)
        if let map = object as? Presenters {
            return map
        }
        
        let map = Presenters()
        objc_setAssociatedObject(self, &keyPlatformViewControllerPresenters, map, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return map
    }
}

