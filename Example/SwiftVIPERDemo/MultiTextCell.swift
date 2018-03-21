//
//  MultiTextCell.swift
//  SwiftVIPERDemo
//
//  Created by Yunarta Kartawahyudi on 6/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cleanse
import Foundation
import RxSwift
import SwiftVIPER

class MultilineTextCellPresenter: VIPERCellPresenter {
    
    let observableText = Variable<String>("default")
    var text: Observable<String> {
        return observableText.asObservable()
    }
    
    func present(table: VIPERTable, data: String) {
        observableText.value = "abc \(data)"
    }
}

class MultilineTextCellViewBinding: UIView, VIPERCellView, ManualLayoutCellView {
    
    func estimateLayoutSize(fit: CGSize) -> CGSize {
        
        return CGSize(width: fit.width, height: fit.height / 10)
    }
    
    func computeLayoutSize(fit: CGSize) -> CGSize {
        return CGSize(width: fit.width, height: fit.height / 10)
    }
    
    weak var presenter: MultilineTextCellPresenter? {
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
    
    func didSelect(table: VIPERTable) {
        if let indexPath = indexPath {
            print("indexPath = \(indexPath)")
        }
    }
}

class MultilineTextCell: UITableViewCell, VIPERTableCellView, ManualLayoutCellView {
    
    var presenter: MultilineTextCellPresenter? = MultilineTextCellPresenter()
    
    @IBOutlet weak var binding: MultilineTextCellViewBinding? {
        didSet {
            binding?.presenter = presenter
        }
    }
}
