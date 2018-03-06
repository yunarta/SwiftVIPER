//
//  MultiTextCell.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 6/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import SwiftVIPER

protocol MultilineTextCellView: VIPERViewInterface {
    
    var text: String { get set }
}

class MultilineTextCellViewImpl: MultilineTextCellView {
    
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

class MultilineTextCellViewBinding: UIView, VIPERCellView, ManualLayoutCellView {
    
    func estimateLayoutSize(fit: CGSize) -> CGSize {
        
        return CGSize(width: fit.width, height: fit.height / 10)
    }
    
    func computeLayoutSize(fit: CGSize) -> CGSize {
        return CGSize(width: fit.width, height: fit.height / 10)
    }
    
    
    let viewImpl = MultilineTextCellViewImpl()
    var view: MultilineTextCellView {
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

class MultilineTextCellPresenter: VIPERCellPresenter {
    
    func present(table: VIPERTable, view: MultilineTextCellView, data: String) {
        view.text = data
    }
}


class MultilineTextCell: UITableViewCell, VIPERTableCellView {
    
    var presenter: MultilineTextCellPresenter? = MultilineTextCellPresenter()
    
    var layoutView: UIView?
    
    var delegate: MultilineTextCellPresenter?
    
    var cellView: MultilineTextCellViewBinding {
        return binding
    }
    
    @IBOutlet weak var binding: MultilineTextCellViewBinding!
}
