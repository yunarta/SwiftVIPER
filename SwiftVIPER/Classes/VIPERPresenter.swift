//
// Created by Yunarta Kartawahyudi on 6/10/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

import Foundation

public protocol VIPERPresenter: class {

    func onActivityResult(of requestCode: Int, with resultCode: Int, intent: Intent?)
}

var keyForPresentingIntent = "keyForPresentingIntent"
var keyForRequestCode = "keyForRequestCode"

/** Extending Intent to create presenting and receiver pattern
 */
extension Intent {

    var presentingIntent: VIPERPresenter? {
        get {
            return objc_getAssociatedObject(self, &keyForPresentingIntent) as? VIPERPresenter
        }

        set(value) {
            objc_setAssociatedObject(self, &keyForPresentingIntent, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    var requestCode: Int {
        get {
            return (objc_getAssociatedObject(self, &keyForRequestCode) as? Int) ?? 0
        }

        set(value) {
            objc_setAssociatedObject(self, &keyForRequestCode, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public protocol VIPERPresenterRouter: VIPERRouter {

    func performRouting(_ intent: Intent, withCode requestCode: Int)
}

class VIPERPresenterRouterImpl: VIPERPresenterRouter {

    weak var router: VIPERRouter?

    weak var presenter: VIPERPresenter?

    public func performRouting(_ intent: Intent, withCode requestCode: Int) {
        intent.presentingIntent = presenter
        intent.requestCode = requestCode

        router?.performRouting(intent)
    }

    func performRouting(_ intent: Intent) {
        router?.performRouting(intent)
    }
}

class VIPERPresenterInternal {

    let router = VIPERPresenterRouterImpl()

    weak var presentingIntent: VIPERPresenter?

    var requestCode: Int = 0

    var pendingResult: ResultDispatch?

//    func dispatchPendingResult() {
//        if let result = pendingResult {
//            // presentingIntent?.onActivityResult(of: 10, with: result.resultCode, intent: result.intent)
//        }
//    }
}

struct ResultDispatch {

    var resultCode: Int

    var intent: Intent?
}

var keyForPresenterInternal = "keyForPresenterInternal"

extension VIPERPresenter {

    var `internal`: VIPERPresenterInternal {
        let instance = objc_getAssociatedObject(self, &keyForPresenterInternal) as? VIPERPresenterInternal
        if let instance = instance {
            return instance
        } else {
            let newInstance = VIPERPresenterInternal()
            objc_setAssociatedObject(self, &keyForPresenterInternal, newInstance, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

            return newInstance
        }
    }

    public func dispatchActivityResult(with resultCode: Int, intent: Intent? = nil) {
        `internal`.pendingResult = ResultDispatch(resultCode: resultCode, intent: intent)
    }

//    func dispatchPendingResult() {
//        `internal`.dispatchPendingResult()
//    }

    public func onActivityResult(of requestCode: Int, with resultCode: Int, intent: Intent?) {

    }
}

/** Exposed properties
 */
extension VIPERPresenter {

    var presentingIntent: VIPERPresenter? {
        return `internal`.presentingIntent
    }

    var requestCode: Int {
        return `internal`.requestCode
    }

    var router: VIPERPresenterRouter {
        return `internal`.router
    }
}
