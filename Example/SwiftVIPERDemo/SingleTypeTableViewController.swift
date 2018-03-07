//
//  ViewController.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftVIPER

class StringData: VIPERTableDataSource, SingleType {

    func creationInfo(table: VIPERTable) -> CellCreationInfo {
        return CellCreationInfo(id: 0, nib: "Text")
    }

    func table(table: VIPERTable, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func present(table: VIPERTable, view: TextCell, at indexPath: IndexPath) {
        view.present(table: table, data: "data \(indexPath.row)")
    }
}

class TextTableView: VIPERViewInterface {
    
}

class TextTableViewBinding: VIPERTableViewBinding, VIPERViewBindingInterface {
    
    let tableData = VIPERTableData<StringData>(dataSource: StringData())
    
    var view = TextTableView()
    
    @IBOutlet weak var tableView: UITableView?
    
    required init() {
        super.init(view: view, tableData: tableData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        tableView.register(UINib(nibName: "SingleLineTextCell", bundle: Bundle.main), forCellReuseIdentifier: "Text")
        tableData.install(to: tableView)
    }
}

class SingleTypeTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchViewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

