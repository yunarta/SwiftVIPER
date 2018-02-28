//
//  VIPERTableDataSource+VIPER.swift
//  SwiftVIPER
//
//  Created by Yunarta Kartawahyudi on 26/2/18.
//

import Foundation

var keyVIPERTableDataSourceRouter = "keyVIPERTableDataSourceRouter"
var keyVIPERTableDataSourceViewContext = "keyVIPERTableDataSourceViewContext"

// MARK: Extension to access VIPER

extension VIPERTableDataSource {
    
    var router: VIPERRouter? {
        get {
            return objc_getAssociatedObject(self, &keyVIPERTableDataSourceRouter) as? VIPERRouter
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableDataSourceRouter, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var viewContext: VIPERViewContext? {
        get {
            return objc_getAssociatedObject(self, &keyVIPERTableDataSourceViewContext) as? VIPERViewContext
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableDataSourceViewContext, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
