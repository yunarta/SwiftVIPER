//
// Created by Yunarta Kartawahyudi on 5/11/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

import UIKit

public typealias CellCreationInfo = (id: Int, nib: String)

public protocol VIPERTable {

}

private var keyVIPERTableRouter = "keyVIPERTableRouter"
private var keyVIPERTableViewContent = "keyVIPERTableViewContent"

extension VIPERTable {
    
    var router: VIPERRouter? {
        get {
            return (objc_getAssociatedObject(self, &keyVIPERTableRouter) as? VIPERRouter)
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableRouter, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var viewContext: VIPERViewContext? {
        get {
            return (objc_getAssociatedObject(self, &keyVIPERTableViewContent) as? VIPERViewContext)
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableViewContent, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

public protocol VIPERTableDataSource: class {

    /** Return number of row available for each section
     */
    func table(table: VIPERTable, numberOfRowsInSection section: Int) -> Int

    /** Give the data source last chance to configure the cell before the presenter starts
     */
    func cell(table: VIPERTable, id: Int, configure cell: VIPERTableCellViewBase, at indexPath: IndexPath)

    /** Call to present the data to the cell, the data source will produce the data and present it to the cell
     */
    func present(table: VIPERTable, cell: VIPERTableCellViewBase, at indexPath: IndexPath)
}

extension VIPERTableDataSource {
    
    public func cell(table: VIPERTable, id: Int, configure cell: VIPERTableCellViewBase, at indexPath: IndexPath) {
        
    }
}

// MARK: - Cell information handler

public protocol SingleType: class {

    associatedtype CellView
    
    /** Return creation information for specific cell index path
     */
    func creationInfo(table: VIPERTable) -> CellCreationInfo
    
    /** Call to present the data to the cell, the data source will produce the data and present it to the cell
     */
    func present(table: VIPERTable, view: CellView, at indexPath: IndexPath)
}

extension SingleType {
    
    public func present(table: VIPERTable, cell: VIPERTableCellViewBase, at indexPath: IndexPath) {
        if let cell = cell as? CellView {
            self.present(table: table, view: cell, at: indexPath)
        }
    }
}

public protocol MixedType: class {

    /** Return creation information for specific cell index path
     */
    func creationInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo
}

