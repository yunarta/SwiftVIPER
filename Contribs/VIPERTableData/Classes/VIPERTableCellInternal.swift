//
//  VIPERTableCellInternal.swift
//  SwiftVIPER
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//

import Foundation

/** Internal side of VIPER CellView, used for storing data used internally
 */

private var keyVIPERCellViewContext = "keyVIPERCellViewContext"

class VIPERCellViewContext {

    weak var cell: (UITableViewCell & VIPERTableCellViewBase)?

    weak var viewContext: VIPERViewContext?

    var tableFrameSize: CGSize = CGSize.zero

    var indexPath: IndexPath?
}

extension VIPERCellView {

    var context: VIPERCellViewContext {
        if let context = objc_getAssociatedObject(self, &keyVIPERCellViewContext) as? VIPERCellViewContext {
            return context
        }

        let context = VIPERCellViewContext()
        objc_setAssociatedObject(self, &keyVIPERCellViewContext, context, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return context
    }
}

/** Internal side of VIPER Table CellView, used for storing data used internally by VIPERTable Data
 */
class VIPERTableCellViewContext {

    var isNeedConfiguration = true

    weak var viewContext: VIPERViewContext?

    weak var router: VIPERRouter?

    var indexPath: IndexPath = IndexPath()

    var isContentChanged: Bool = true
}

private var keyVIPERTableCellViewBaseLayoutRequired = "keyVIPERTableCellViewBaseLayoutRequired"
private var keyVIPERTableCellContext = "keyVIPERTableCellContext"

extension VIPERTableCellViewBase {

    var context: VIPERTableCellViewContext {
        if let context = objc_getAssociatedObject(self, &keyVIPERTableCellContext) as? VIPERTableCellViewContext {
            return context
        }

        let context = VIPERTableCellViewContext()
        objc_setAssociatedObject(self, &keyVIPERTableCellContext, context, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return context
    }

    func configureContext<E>(from data: VIPERTableData<E>) {
        context.router = data.router
        context.viewContext = data.viewContext
    }
}
