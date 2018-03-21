//
//  MultiTypeTableViewController.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 6/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import SwiftVIPER

class MultiTypeData: VIPERTableDataSource, MixedType {

    func present(table: VIPERTable, cell: VIPERTableCellViewBase, at indexPath: IndexPath) {
        switch (indexPath.row % 2, cell) {
        case (0, let view as TextCell):
            view.present(table: table, data: "data \(indexPath.row)")

        case (1, let view as MultilineTextCell):
            view.present(table: table, data: "data \(indexPath.row)")

        default:
            break
        }
    }

    func cellInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo {
        switch indexPath.row % 2 {
        case 0:
            return CellCreationInfo(id: 0, nib: "Text")

        default:
            return CellCreationInfo(id: 1, nib: "Manual")
        }
    }

    func table(table: VIPERTable, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

class MultiTypeTableViewBinding: VIPERTableViewBinding, VIPERViewBindingInterface {

    let tableData = VIPERTableData<MultiTypeData>(dataSource: MultiTypeData())

    @IBOutlet weak var tableView: UITableView?

    required init() {
        super.init(tableData: tableData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else {
            return
        }

        tableView.register(UINib(nibName: "SingleLineTextCell", bundle: Bundle.main), forCellReuseIdentifier: "Text")
        tableView.register(UINib(nibName: "MultiLineTextCell", bundle: Bundle.main), forCellReuseIdentifier: "Manual")

        tableData.install(to: tableView)
        tableView.scrollToRow(at: IndexPath(row: 40, section: 0), at: .bottom, animated: false)
    }
}

class MultiTypeTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchViewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
