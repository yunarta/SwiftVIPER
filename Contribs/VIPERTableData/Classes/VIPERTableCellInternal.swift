//
//  VIPERTableCellInternal.swift
//  SwiftVIPER
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//

import Foundation

/** Internal side of VIPER Table CellView, used for storing data used internally by VIPERTable Data
 */
class VIPERCellViewContext {
    
    var isNeedConfiguration = true
    
    public internal (set) weak var viewContext: VIPERViewContext?
    
    public internal (set) weak var router: VIPERRouter?
    
    public internal (set) var indexPath: IndexPath = IndexPath()
}

var keyVIPERTableCellViewBaseLayoutRequired = "keyVIPERTableCellViewBaseLayoutRequired"
var keyVIPERTableCellContext = "keyVIPERTableCellContext"

extension VIPERTableCellViewBase {
    
    var isContentChanged: Bool {
        get {
            return (objc_getAssociatedObject(self, &keyVIPERTableCellViewBaseLayoutRequired) as? Bool) ?? true
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableCellViewBaseLayoutRequired, value, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
    }
    
    var context: VIPERCellViewContext {
        if let context = objc_getAssociatedObject(self, &keyVIPERTableCellContext) as? VIPERCellViewContext {
            return context
        }
        
        let context = VIPERCellViewContext()
        objc_setAssociatedObject(self, &keyVIPERTableCellContext, context, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return context
    }
    
    func configureContext(from dataSource: VIPERTableDataSource) {
        context.router = dataSource.router
        context.viewContext = dataSource.viewContext
    }
}
