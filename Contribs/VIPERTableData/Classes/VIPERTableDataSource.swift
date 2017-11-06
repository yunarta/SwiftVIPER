//
// Created by Yunarta Kartawahyudi on 5/11/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

import UIKit

public protocol VIPERTable {

}

public protocol VIPERTableDataSource: class {

    func cell(table: VIPERTable, idForRowAt indexPath: IndexPath) -> String

    func cell(table: VIPERTable, typeForRowAt indexPath: IndexPath) -> Int

    /** Give the data source last chance to configure the cell before the presenter starts
     */
    func cell(table: VIPERTable, viewType type: Int, configure cell: VIPERTableViewCell, at indexPath: IndexPath)

    /** Call to present the data to the cell, the data source will produce the data and present it to the cell
     */
    func present(table: VIPERTable, cell: VIPERTableViewCell, at indexPath: IndexPath)
}

var keyVIPERTableDataSourceRouter = "keyVIPERTableDataSourceRouter"
var keyVIPERTableDataSourceViewContext = "keyVIPERTableDataSourceViewContext"

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

    func cell(table: VIPERTable, configure cell: VIPERTableViewCell, at indexPath: IndexPath) {
        let viewType = self.cell(table: table, typeForRowAt: indexPath)
        self.cell(table: table, viewType: viewType, configure: cell, at: indexPath)
    }
}

class VIPERTableData<DataSource>: NSObject, VIPERTable, UITableViewDataSource where DataSource: VIPERTableDataSource {

    var dataSource: DataSource

    init(_ dataSource: DataSource) {
        self.dataSource = dataSource
        super.init()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: dataSource.cell(table: self, idForRowAt: indexPath)) {
            if let cell = cell as? VIPERTableViewCell {
                let context = cell.context

                context.indexPath = indexPath
                if context.isNeedConfiguration {
                    cell.configureContext(from: dataSource)
                }

                dataSource.cell(table: self, configure: cell, at: indexPath)
                dataSource.present(table: self, cell: cell, at: indexPath)
            }

            return cell
        }

        assertionFailure("No cell is generated with id of \(dataSource.cell(table: self, idForRowAt: indexPath))")
        return UITableViewCell()
    }
}
