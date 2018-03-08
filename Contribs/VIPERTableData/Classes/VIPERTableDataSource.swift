//
// Created by Yunarta Kartawahyudi on 5/11/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

import UIKit

private var keyVIPERTableRouter = "keyVIPERTableRouter"
private var keyVIPERTableViewContent = "keyVIPERTableViewContent"

public typealias CellCreationInfo = (id: Int, nib: String)

public protocol VIPERTable: class {

    func install(to table: UITableView)
}

extension VIPERTable {
    
    public var router: VIPERRouter? {
        get {
            return (objc_getAssociatedObject(self, &keyVIPERTableRouter) as? VIPERRouter)
        }
        
        set(value) {
            objc_setAssociatedObject(self, &keyVIPERTableRouter, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var viewContext: VIPERViewContext? {
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
    
    func cell(table: VIPERTable, willSelect cell: VIPERTableCellViewBase) -> Bool
    
    func cell(table: VIPERTable, didSelect cell: VIPERTableCellViewBase) -> Bool
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
    func cellInfo(table: VIPERTable) -> CellCreationInfo
    
    /** Call to present the data to the cell, the data source will produce the data and present it to the cell
     */
    func present(table: VIPERTable, view: CellView, at indexPath: IndexPath)
    
    func view(table: VIPERTable, willSelect view: CellView) -> Bool
    
    func view(table: VIPERTable, didSelect view: CellView) -> Bool
}

extension SingleType {
    
    public func present(table: VIPERTable, cell: VIPERTableCellViewBase, at indexPath: IndexPath) {
        if let cell = cell as? CellView {
            self.present(table: table, view: cell, at: indexPath)
        }
    }
    
    public func cell(table: VIPERTable, willSelect cell: VIPERTableCellViewBase) -> Bool {
        if let cell = cell as? CellView {
            return self.view(table: table, willSelect: cell)
        }
        
        return false
    }
    
    public func view(table: VIPERTable, willSelect view: CellView) -> Bool {
        return false
    }
    
    public func cell(table: VIPERTable, didSelect cell: VIPERTableCellViewBase) -> Bool {
        if let cell = cell as? CellView {
            return self.view(table: table, willSelect: cell)
        }
        
        return false
    }
    
    public func view(table: VIPERTable, didSelect view: CellView) -> Bool {
        return false
    }
}

public protocol MixedType: class {

    /** Return creation information for specific cell index path
     */
    func cellInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo
    
    func cell(table: VIPERTable, willSelect cell: VIPERTableCellViewBase) -> Bool
    
    func cell(table: VIPERTable, didSelect cell: VIPERTableCellViewBase) -> Bool
}

extension MixedType {
    
    public func cell(table: VIPERTable, willSelect cell: VIPERTableCellViewBase) -> Bool {
        return false
    }
    
    public func cell(table: VIPERTable, didSelect cell: VIPERTableCellViewBase) -> Bool {
        return false
    }
}

