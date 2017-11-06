//
// Created by Yunarta Kartawahyudi on 6/11/17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

public protocol VIPERCellView: class {

}

var keyVIPERCellViewCell = "keyVIPERCellViewCell"
var keyVIPERCellViewContext = "keyVIPERCellViewContext"

extension VIPERCellView {

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
}

public class VIPERCellContext {

    var isNeedConfiguration = true

    public internal (set) weak var viewContext: VIPERViewContext?

    public internal (set) weak var router: VIPERRouter?

    public internal (set) var indexPath: IndexPath = IndexPath()
}

public protocol VIPERCellPresenter {

    associatedtype View: VIPERCellView

    associatedtype Data

    func present(table: VIPERTable, context: VIPERCellContext, view: View, data: Data)
}

public class CellPresenterController<Delegate> where Delegate: VIPERCellPresenter {

}

public protocol VIPERTableViewCell {

    var contentView: UIView { get }

    var backgroundView: UIView? { get set }

    var selectedBackgroundView: UIView? { get set }
}

extension VIPERTableViewCell {

    public var context: VIPERCellContext {
        if let context = objc_getAssociatedObject(self, &keyVIPERTableCellContext) as? VIPERCellContext {
            return context
        }

        let context = VIPERCellContext()
        objc_setAssociatedObject(self, &keyVIPERTableCellContext, context, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)

        return context
    }

    func configureContext(from dataSource: VIPERTableDataSource) {
        context.router = dataSource.router
        context.viewContext = dataSource.viewContext
    }
}

public protocol VIPERTableCell: VIPERTableViewCell {

    associatedtype Presenter: VIPERCellPresenter

    var delegate: Presenter? { get set }

    var view: Presenter.View? { get set }
}

var keyVIPERTableCellContext = "keyVIPERTableCellContext"

extension VIPERTableCell where Self: UITableViewCell {

    public func present(table: VIPERTable, data: Presenter.Data) {
        guard let delegate = self.delegate, let view = self.view else {
            return
        }

        view.cell = self
        view.viewContext = context.viewContext
        delegate.present(table: table, context: context, view: view, data: data)
    }
}
