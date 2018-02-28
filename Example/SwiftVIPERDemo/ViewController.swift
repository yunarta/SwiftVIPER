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

class TextCell2: VIPERTableCell<TextCellPresenter, TextCellViewBinding> {
  
    @IBOutlet weak var binding: TextCellViewBinding! {
        didSet {
            cellView = binding
        }
    }
    
    override func awakeFromNib() {
        presenter = TextCellPresenter()
    }
}

class StringData: VIPERTableDataSource, SingleType {

    func creationInfo(table: VIPERTable) -> CellCreationInfo {
        return CellCreationInfo(id: 0, nib: "Text")
    }

    func table(table: VIPERTable, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func present(table: VIPERTable, view: TextCell2, at indexPath: IndexPath) {
        view.present(table: table, data: "data \(indexPath.row)")
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    let data = VIPERTableData<StringData>(dataSource: StringData())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = data
        tableView?.dataSource = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

