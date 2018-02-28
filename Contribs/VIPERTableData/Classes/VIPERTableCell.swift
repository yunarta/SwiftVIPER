//
// Created by Yunarta Kartawahyudi on 6/11/17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//



var keyVIPERCellViewCell = "keyVIPERCellViewCell"
var keyVIPERCellViewContext = "keyVIPERCellViewContext"

// MARK: - VIPER View

/** The VIPER View class in VIPERUIKitTable
 */
public protocol VIPERCellViewBase: class {
    
    func estimateLayoutSize() -> CGSize
    
    func computeLayoutSize() -> CGSize
}

extension VIPERCellViewBase {

    public var cell: UITableViewCell? {
        get {
            return objc_getAssociatedObject(self, &keyVIPERCellViewCell) as? UITableViewCell
        }

        set(value) {
            objc_setAssociatedObject(self, &keyVIPERCellViewCell, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public var viewContext: VIPERViewContext? {
        get {
            return objc_getAssociatedObject(self, &keyVIPERCellViewContext) as? VIPERViewContext
        }

        set(value) {
            objc_setAssociatedObject(self, &keyVIPERCellViewContext, value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func estimateLayoutSize() -> CGSize {
        return CGSize.zero
    }
    
    public func computeLayoutSize() -> CGSize {
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
    
    func estimateLayoutSize() -> CGSize
    
    func computeLayoutSize() -> CGSize
    
    // MARK: - UITableViewCell
    var contentView: UIView { get }

    var backgroundView: UIView? { get set }

    var selectedBackgroundView: UIView? { get set }
}

/** VIPER TableCellView class used conform UITableViewCell into VIPER UIKitTable
 */
public protocol VIPERTableCellView: VIPERTableCellViewBase {

    associatedtype Presenter: VIPERCellPresenter

    typealias PresenterView = Presenter.View
    
    associatedtype CellView: VIPERCellView
    
    var presenter: Presenter? { get set }
    
    var cellView: CellView { get }
}

open class VIPERTableCell<Presenter, CellView>: UITableViewCell, VIPERTableCellViewBase where Presenter: VIPERCellPresenter, CellView: VIPERCellView, Presenter.View == CellView.View {
    
    public var presenter: Presenter?
    
    public weak var cellView: CellView?
    
    public var layoutMode: VIPERTableCellViewLayoutMode = .autoLayout
    
    public var layoutView: UIView?

    public func estimateLayoutSize() -> CGSize {
        return cellView?.estimateLayoutSize() ?? CGSize.zero
    }
    
    public func computeLayoutSize() -> CGSize {
        return cellView?.estimateLayoutSize() ?? CGSize.zero
    }
    
    public func present(table: VIPERTable, data: Presenter.Data) {
        guard let presenter = self.presenter, let cellView = cellView else {
            return
        }
        cellView.cell = self
        cellView.viewContext = context.viewContext
        
        presenter.present(table: table, view: cellView.view, data: data)
    }
}

public class CellPresenterController<Delegate> where Delegate: VIPERCellPresenter {
    
}
