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
extension VIPERTable {
    
    func install(router: VIPERRouter?, viewContext: VIPERViewContext?) {
        self.router = router
        self.viewContext = viewContext
    }
}

extension VIPERTableDataSource {
    
}
