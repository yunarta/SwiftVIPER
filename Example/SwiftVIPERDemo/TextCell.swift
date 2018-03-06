//
//  TextCell.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 6/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
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

class TextCellViewBinding: UIView, VIPERCellView, AutoLayoutCellView {
    
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
        
    var layoutView: UIView?
    
    var delegate: TextCellPresenter?
    
    var cellView: TextCellViewBinding {
        return binding
    }
    
    @IBOutlet weak var binding: TextCellViewBinding!
}
