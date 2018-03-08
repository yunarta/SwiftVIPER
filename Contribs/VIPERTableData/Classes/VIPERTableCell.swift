//
// Created by Yunarta Kartawahyudi on 6/11/17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import UIKit

var keyVIPERCellViewCell = "keyVIPERCellViewCell"
var keyVIPERCellViewContext = "keyVIPERCellViewContext"
var keyVIPERCellViewTableFrameSize = "keyVIPERCellViewTableFrameSize"
var keyVIPERCellViewIndexPath = "keyVIPERCellViewTableIndexPath"

// MARK: - VIPER View

/** The VIPER View class in VIPERUIKitTable
 */
public protocol VIPERCellViewBase: class {
    
    func estimateLayoutSize(fit: CGSize) -> CGSize
    
    func computeLayoutSize(fit: CGSize) -> CGSize
    
    func willSelect(table: VIPERTable)
    
    func didSelect(table: VIPERTable)
}

public protocol AutoLayoutCellView {
    
}

public protocol ManualLayoutCellView {
    
}

extension VIPERCellViewBase {
    
    public var viewContext: VIPERViewContext? {
        get {
            return context.viewContext
        }
        
        set(value) {
            context.viewContext = value
        }
    }
    
    public internal (set) var cell: (UITableViewCell & VIPERTableCellViewBase)? {
        get {
            return context.cell
        }

        set(value) {
            context.cell = value
        }
    }

    
    public internal (set) var tableFrameSize: CGSize {
        get {
            return context.tableFrameSize
        }
        
        set(value) {
            context.tableFrameSize = value
        }
    }
  
    public internal (set) var indexPath: IndexPath? {
        get {
            return context.indexPath
        }
        
        set(value) {
            context.indexPath = value
        }
    }
    
    public func willSelect(table: VIPERTable) {
        
    }
    
    public func didSelect(table: VIPERTable) {
        
    }
}

extension VIPERCellViewBase where Self: AutoLayoutCellView {
    
    public func estimateLayoutSize(fit: CGSize) -> CGSize {
        return CGSize.zero
    }
    
    public func computeLayoutSize(fit: CGSize) -> CGSize {
        return CGSize.zero
    }
}

public protocol VIPERCellView: VIPERCellViewBase {
    
    associatedtype View
    
    var view: View { get }
}

// MARK: - VIPER Presenter

/** The VIPER Presenter class in VIPERUIKitTable
 */
public protocol VIPERCellPresenter: class {

    associatedtype View

    associatedtype Data
    
    func present(table: VIPERTable, view: View, data: Data)
}

public enum VIPERTableCellViewLayoutMode: Int {
    
    case autoLayout
    case manualLayout
}

/** VIPER TableCell View base class used by VIPERTable Data without PAT constraint.
 */
public protocol VIPERTableCellViewBase {
    
    // MARK: - VIPERTableCellViewBase - layout
    
    var layoutMode: VIPERTableCellViewLayoutMode { get }
    
    /** Used by auto layout to determined the height, it will use contentView if its nil
     */
    var layoutView: UIView? { get }
    
    func estimateLayoutSize(fit: CGSize) -> CGSize
    
    func computeLayoutSize(fit: CGSize) -> CGSize
    
    // MARK: - UITableViewCell
    var contentView: UIView { get }

    var backgroundView: UIView? { get set }

    var selectedBackgroundView: UIView? { get set }
    
    func willSelect(table: VIPERTable)
    
    func didSelect(table: VIPERTable)
}

extension VIPERTableCellViewBase {
    
}

/** VIPER TableCellView class used conform UITableViewCell into VIPER UIKitTable
 */
public protocol VIPERTableCellView: VIPERTableCellViewBase {

    associatedtype Presenter: VIPERCellPresenter

    associatedtype CellView: VIPERCellView
    
    typealias PresenterView = Presenter.View
    
    var presenter: Presenter? { get set }

    var cellView: CellView { get }
    
    func estimateLayoutSize(fit: CGSize) -> CGSize
    
    func computeLayoutSize(fit: CGSize) -> CGSize
}

/** Internal side of VIPER Table CellView, used for delegating layout and presenter method used internally by VIPERTable Data
 */
extension VIPERTableCellView where Self: UITableViewCell, CellView: AutoLayoutCellView {
    
    public var layoutMode: VIPERTableCellViewLayoutMode {
        return .autoLayout
    }
    
    public func estimateLayoutSize(fit: CGSize) -> CGSize {
        return CGSize.zero
    }
    
    public func computeLayoutSize(fit: CGSize) -> CGSize {
        return CGSize.zero
    }
}

extension VIPERTableCellView where Self: UITableViewCell, CellView: ManualLayoutCellView {
    
    public var layoutMode: VIPERTableCellViewLayoutMode {
        return .manualLayout
    }
    
    public func estimateLayoutSize(fit: CGSize) -> CGSize {
        return cellView.estimateLayoutSize(fit: fit)
    }
    
    public func computeLayoutSize(fit: CGSize) -> CGSize {
        return cellView.estimateLayoutSize(fit: fit)
    }
}

extension VIPERTableCellView where Self: UITableViewCell {
     
    public func present(table: VIPERTable, data: Presenter.Data) {
        guard let presenter = self.presenter else {
            return
        }
        
        cellView.context.cell = self
        cellView.context.indexPath = context.indexPath
        cellView.viewContext = context.viewContext
        
        assert(cellView.view is PresenterView)
        if let cell = cellView.view as? PresenterView {
            presenter.present(table: table, view: cell, data: data)
        }
    }
    
    public func willSelect(table: VIPERTable) {
        cellView.context.cell = self
        cellView.context.indexPath = context.indexPath
        cellView.viewContext = context.viewContext
        
        cellView.willSelect(table: table)
    }
    
    public func didSelect(table: VIPERTable) {
        cellView.context.cell = self
        cellView.context.indexPath = context.indexPath
        cellView.viewContext = context.viewContext
        
        cellView.didSelect(table: table)
    }
}

