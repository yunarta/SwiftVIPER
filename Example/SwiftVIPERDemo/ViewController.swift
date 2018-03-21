//
//  ViewController.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftVIPER

protocol TextCellView: VIPERViewInterface {
    
    var text: String { get set }
}

class TextCellViewImpl: TextCellView {
    
    let observableText = VIPERField<String>("default")
    var text: String {
        get {
            return observableText.value
        }
        
        set {
            observableText.value = newValue
        }
    }
}

class TextCellViewBinding: UIView, VIPERCellView {
    
    let viewImpl = TextCellViewImpl()
    var view: TextCellView {
        return viewImpl
    }
    
    @IBOutlet weak var label: UILabel! {
        didSet {
            viewImpl.observableText.onChange { [weak self] value in
                
                print("cell = \(String(describing: self?.cell))")
                print("viewContext = \(String(describing: self?.viewContext))")
                
                self?.label.text = "abc \(value)"
            }
        }
    }
}

class TextCellPresenter: VIPERCellPresenter {
     
    func present(table: VIPERTable, view: TextCellView, data: String) {
        view.text = data
    }
}


class TextCell: UITableViewCell, VIPERTableCellView {
 
    var presenter: TextCellPresenter? = TextCellPresenter()

    var layoutMode: VIPERTableCellViewLayoutMode = .autoLayout

    var layoutView: UIView?

    var delegate: TextCellPresenter?

    var cellView: TextCellViewBinding {
        return binding
    }

    @IBOutlet weak var binding: TextCellViewBinding!
}

class StringData: VIPERTableDataSource, SingleType {

    func creationInfo(table: VIPERTable) -> CellCreationInfo {
        return CellCreationInfo(id: 0, nib: "Text")
    }

    func table(table: VIPERTable, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        
        tableData.install(to: tableView)
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchViewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

