//
//  TextCell.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 6/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import SwiftVIPER

class TextCellView {
    
    
}

class TextCellPresenter: VIPERCellPresenter {
    
    let observableText = Variable<String>("default")
    var text: Observable<String> {
        return observableText.asObservable()
    }
    
    func present(table: VIPERTable, data: String) {
        observableText.value = "abc \(data)"
    }
}

class TextCellViewBinding: UIView, VIPERCellView, AutoLayoutCellView {
    
    let view = TextCellView()
    
    var presenter: TextCellPresenter? {
        didSet {
            guard let presenter = presenter else {
                return
            }
            
            disposeBag.insert(presenter.text.subscribe(onNext: { [weak self] value in
                self?.label?.text = value
            }))
        }
    }
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var label: UILabel?
}

class TextCell: UITableViewCell, VIPERTableCellView {
    
    var presenter: TextCellPresenter? = TextCellPresenter()
        
    var layoutView: UIView?
    
    var delegate: TextCellPresenter?
    
    var cellView: TextCellViewBinding {
        return binding
    }
    
    @IBOutlet weak var binding: TextCellViewBinding! {
        didSet {
            cellView.presenter = presenter
        }
    }
}
