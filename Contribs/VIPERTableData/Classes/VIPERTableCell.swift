//
// Created by Yunarta Kartawahyudi on 6/11/17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import UIKit

/** The VIPER View class in VIPERUIKitTable
 */
public protocol VIPERCellView: class {

    func willSelect(table: VIPERTable)

    func didSelect(table: VIPERTable)
}

/** Default function implementation for VIPERCellViewBase
 */
extension VIPERCellView {

    public func willSelect(table: VIPERTable) {

    }

    public func didSelect(table: VIPERTable) {

    }
}

/** Accessible properties for VIPERCellViewBase
 */
extension VIPERCellView {

    /** VIPERViewContext where you can retrieve the controller hosting this cell
     */
    public internal (set) var viewContext: VIPERViewContext? {
        get {
            return context.viewContext
        }

        set(value) {
            context.viewContext = value
        }
    }

    /** UIKit UITableViewCell instance
     */
    public internal (set) var cell: (UITableViewCell & VIPERTableCellViewBase)? {
        get {
            return context.cell
        }

        set(value) {
            context.cell = value
        }
    }

    /** The table frame size that can be used for fine tuning calculation
     */
    public internal (set) var tableFrameSize: CGSize {
        get {
            return context.tableFrameSize
        }

        set(value) {
            context.tableFrameSize = value
        }
    }

    /** Current cell index path.
        It will be nil when the cell is a estimate purpose cell
     */
    public internal (set) var indexPath: IndexPath? {
        get {
            return context.indexPath
        }

        set(value) {
            context.indexPath = value
        }
    }
}

/** Companion class of VIPER CellView for auto layout cell view
    Conforming to AutoLayoutCellView will gives you default estimateLayoutSize and computeLayoutSize implementation.
 */
public protocol AutoLayoutCellView {

}

extension VIPERCellView where Self: AutoLayoutCellView {

}

/** Companion class of VIPER CellView for manual layout cell view
    Conforming to AutoLayoutCellView will gives you default estimateLayoutSize and computeLayoutSize implementation.
 */
public protocol ManualLayoutCellView {

    func estimateLayoutSize(fit: CGSize) -> CGSize

    func computeLayoutSize(fit: CGSize) -> CGSize
}

/** Layout mode of the table cell view
 */
public enum VIPERTableCellViewLayoutMode: Int {

    case autoLayout
    case manualLayout
}

#if DEBUG
extension VIPERTableCellViewLayoutMode: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .autoLayout:
            return "🅰️"

        case .manualLayout:
            return "Ⓜ️"
        }
    }
}
#endif

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

    // MARK: - VIPERTableCellViewBase - internally used
    func willSelect(table: VIPERTable)

    func didSelect(table: VIPERTable)

    // MARK: - UITableViewCell
    var contentView: UIView { get }

    var backgroundView: UIView? { get set }

    var selectedBackgroundView: UIView? { get set }
}

/** VIPER TableCellView class used conform UITableViewCell into VIPER UIKitTable
 */
public protocol VIPERTableCellView: VIPERTableCellViewBase {

    associatedtype Presenter: VIPERCellPresenter

    associatedtype CellView: VIPERCellView

    var presenter: Presenter? { get set }

    weak var binding: CellView? { get set }

    func estimateLayoutSize(fit: CGSize) -> CGSize

    func computeLayoutSize(fit: CGSize) -> CGSize
}

/** Internal side of VIPER Table CellView, used for delegating layout and presenter method used internally by VIPERTable Data
 */
var keyVIPERTableCellViewLayoutView = "keyVIPERTableCellViewLayoutView"
var keyVIPERTableCellViewCellView = "keyVIPERTableCellViewCellView"

extension VIPERTableCellView where Self: UITableViewCell {

    public func present(table: VIPERTable, data: Presenter.Data) {
        guard let presenter = self.presenter, let binding = self.binding else {
            return
        }

        binding.context.cell = self
        binding.context.indexPath = context.indexPath
        binding.viewContext = context.viewContext

        presenter.present(table: table, data: data)
    }

    public func willSelect(table: VIPERTable) {
        guard let binding = self.binding else {
            return
        }

        binding.context.cell = self
        binding.context.indexPath = context.indexPath
        binding.viewContext = context.viewContext

        binding.willSelect(table: table)
    }

    public func didSelect(table: VIPERTable) {
        guard let binding = self.binding else {
            return
        }

        binding.context.cell = self
        binding.context.indexPath = context.indexPath
        binding.viewContext = context.viewContext

        binding.didSelect(table: table)
    }
}

extension VIPERTableCellView where Self: UITableViewCell, CellView: AutoLayoutCellView {

    public var layoutMode: VIPERTableCellViewLayoutMode {
        return .autoLayout
    }

    public func estimateLayoutSize(fit: CGSize) -> CGSize {
        return systemLayoutFitting(layoutView ?? contentView, width: fit.width)
    }

    public func computeLayoutSize(fit: CGSize) -> CGSize {
        return systemLayoutFitting(layoutView ?? contentView, width: fit.width)
    }
}

private func systemLayoutFitting(_ view: UIView, width: CGFloat) -> CGSize {
    return view.systemLayoutSizeFitting(CGSize(width: width, height: 0),
                                        withHorizontalFittingPriority: UILayoutPriority.required,
                                        verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
}

extension VIPERTableCellView where Self: UITableViewCell, CellView: ManualLayoutCellView {

    public var layoutView: UIView? {
        return nil
    }

    public var layoutMode: VIPERTableCellViewLayoutMode {
        return .manualLayout
    }

    public func estimateLayoutSize(fit: CGSize) -> CGSize {
        guard let view = self.binding else {
            return CGSize.zero
        }

        return view.estimateLayoutSize(fit: fit)
    }

    public func computeLayoutSize(fit: CGSize) -> CGSize {
        guard let view = self.binding else {
            return CGSize.zero
        }

        return view.computeLayoutSize(fit: fit)
    }
}

// MARK: - VIPER Presenter

/** The VIPER Presenter class in VIPERUIKitTable
 */
public protocol VIPERCellPresenter: class {

    associatedtype Data

    func present(table: VIPERTable, data: Data)
}
