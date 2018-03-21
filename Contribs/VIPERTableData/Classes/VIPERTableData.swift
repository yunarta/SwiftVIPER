//
//  VIPERTableData.swift
//  SwiftVIPER
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//

import Foundation

#if DEBUG
public struct Debug {
    public let logEstimate: Bool
    public let logHit: Bool
    public let logMiss: Bool

    internal func log(_ level: Level = .op, cache: CacheHit = .noop, _ message: String) {
        switch level {
        case .estimate:
            guard logEstimate else {
                return
            }

        default:
            break
        }

        switch cache {
        case .hit:
            guard logHit else {
                return
            }

        case .miss:
            guard logMiss else {
                return
            }

        default:
            break
        }

        print(message)
    }
}

internal enum Level {
    case op
    case estimate
    case height
}

internal enum CacheHit {
    case noop
    case hit
    case miss
}

#endif

protocol DataSourceHandler {

    var dataSource: VIPERTableDataSource? { get }

    func cellInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo?
}

class SingleTypeHandler<S>: DataSourceHandler where S: VIPERTableDataSource & SingleType {

    var dataSource: VIPERTableDataSource? {
        return singleType
    }

    weak var singleType: S?

    init(_ dataSource: S) {
        self.singleType = dataSource
    }

    func cellInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo? {
        return singleType?.cellInfo(table: table)
    }
}

class MixedTypeHandler: DataSourceHandler {

    var dataSource: VIPERTableDataSource? {
        return mixedType
    }

    weak var mixedType: (VIPERTableDataSource & MixedType)?

    init(_ dataSource: VIPERTableDataSource & MixedType) {
        self.mixedType = dataSource
    }

    func cellInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo? {
        return mixedType?.cellInfo(table: table, at: indexPath)
    }
}

struct VIPERCellCache {

    var cell: VIPERTableCellViewBase
}

class VIPERTableCache {

    var inUse = [Int: VIPERTableCellViewBase]()

    /** Cached height is height that is produced during heightForRowAt event
     */
    var cachedHeights = [Int: CGFloat]()

    /** Cell created during estimatedHeightForRowAt or heightForRowAt event when executed without cellForRowAt event
     */
    var cachedCell = [Int: VIPERCellCache]()

    /** Estimated height, each cell type only have one height estimation
     */
    var estimatedHeights = [Int: CGFloat]()
}

// MARK: - VIPERTableData

public struct VIPERTableOptions {

    var optimizeAutomaticRowHeight: Bool = false

    var automaticDeselectRow: Bool = true

    public init() {

    }
}

open class VIPERTableData<DataSource>: NSObject, VIPERTable, UITableViewDataSource, UITableViewDelegate where DataSource: VIPERTableDataSource {

    public var dataSource: DataSource

    var handler: DataSourceHandler

    var options: VIPERTableOptions

    // MARK: - Cell caching

    let caches = VIPERTableCache()

#if DEBUG
    var debug: Debug?
#endif

    // MARK: - Init

    init(dataSource: DataSource, handler: DataSourceHandler, options: VIPERTableOptions) {
        self.dataSource = dataSource
        self.handler = handler
        self.options = options

        super.init()
    }

    open func install(to table: UITableView) {
        table.dataSource = self
        table.delegate = self
    }

    // MARK: - UITableViewDataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.table(table: self, numberOfRowsInSection: section)
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let (id, nib) = handler.cellInfo(table: self, at: indexPath),
           let cell = tableView.dequeueReusableCell(withIdentifier: nib) {
            if let cell = cell as? VIPERTableCellViewBase {
                let context = cell.context

                context.indexPath = indexPath
                if context.isNeedConfiguration {
                    cell.configureContext(from: self)
                }

                dataSource.cell(table: self, id: id, configure: cell, at: indexPath)
                dataSource.present(table: self, cell: cell, at: indexPath)

                caches.inUse[indexPath.section * 10_000 + indexPath.row] = cell
            }

            return cell
        }

        // assertionFailure("No cell is generated with id of \(dataSource.cellType(table: self, idForRowAt: indexPath))")
        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? VIPERTableCellViewBase else {
            return nil
        }

        if dataSource.cell(table: self, willSelect: cell) {
            return indexPath
        }

        cell.willSelect(table: self)
        return indexPath
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            if options.automaticDeselectRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? VIPERTableCellViewBase else {
            return
        }

        if dataSource.cell(table: self, didSelect: cell) {
            return
        }

        cell.didSelect(table: self)
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        caches.inUse[indexPath.section * 10_000 + indexPath.row] = nil
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if options.optimizeAutomaticRowHeight {
            return UITableViewAutomaticDimension
        }

        let indexKey: Int = indexPath.section * 10_000 + indexPath.row
        let separatorHeight: CGFloat = tableView.separatorStyle == .none ? 0.0 : 1.0

        // get cell from in use caches
        if let inUse: VIPERTableCellViewBase = caches.inUse[indexKey] {
            inUse.context.indexPath = indexPath
            // we are being called after cell acquisition
            if let height = caches.cachedHeights[indexKey] {
                if inUse.layoutMode == .autoLayout || inUse.context.isContentChanged == false {
                    // for auto layout cell, we use the available height
#if DEBUG
                    debug?.log(.height, cache: .hit, "\(indexPath) calculate cache hit for \(inUse.layoutMode)️ layout, height = \(height)")
#endif

                    return height
                }
            }

            // populate cell with real data
            dataSource.present(table: self, cell: inUse, at: indexPath)

            let calculatedHeight: CGFloat
            let layoutSize: CGSize = inUse.computeLayoutSize(fit: tableView.frame.size)
            inUse.context.isContentChanged = false

            calculatedHeight = layoutSize.height + separatorHeight
#if DEBUG
            debug?.log(.height, cache: .miss, "\(indexPath) calculate cache miss for \(inUse.layoutMode) layout, height = \(calculatedHeight)")
#endif
            caches.cachedHeights[indexKey] = calculatedHeight
            return calculatedHeight
        } else {
            // we are being called for content size and scroll estimation
            if let cached: VIPERCellCache = retrieveCachedCell(tableView, forRow: indexPath) {
                let cell: VIPERTableCellViewBase = cached.cell
                cell.context.indexPath = indexPath

                // populate cell with real data
                dataSource.present(table: self, cell: cell, at: indexPath)

                let calculatedHeight: CGFloat
                // for manual cell, we will recalculate the height if the content has changed
                let layoutSize: CGSize = cell.computeLayoutSize(fit: tableView.frame.size)
                cell.context.isContentChanged = false

                calculatedHeight = layoutSize.height + separatorHeight
#if DEBUG
                debug?.log(.height, cache: .miss, "\(indexPath) post-estimate cache miss for \(cell.layoutMode)️ layout, height = \(calculatedHeight)")
#endif
                caches.cachedHeights[indexKey] = calculatedHeight
                return calculatedHeight
            }
        }

        return 0
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if options.optimizeAutomaticRowHeight {
            return UITableViewAutomaticDimension
        }

        guard let (id, _) = handler.cellInfo(table: self, at: indexPath) else {
            return 0
        }

        // let indexKey: Int = indexPath.section * 10_000 + indexPath.row
        let separatorHeight: CGFloat = tableView.separatorStyle == .none ? 0.0 : 1.0

        if let estimated = caches.estimatedHeights[id] {
#if DEBUG
            debug?.log(.estimate, "\(indexPath) estimate cache hit, height = \(estimated)")
#endif
            return estimated
        }

        // we are being called for content size and scroll estimation
        if let cached: VIPERCellCache = retrieveCachedCell(tableView, forRow: indexPath) {
            let cell: VIPERTableCellViewBase = cached.cell

            let calculatedHeight: CGFloat
            let layoutSize: CGSize = cell.estimateLayoutSize(fit: tableView.frame.size)
            cell.context.isContentChanged = false

            calculatedHeight = layoutSize.height + separatorHeight

#if DEBUG
            debug?.log(.estimate, cache: .miss,
                "\(indexPath) estimate cache miss for \(cell.layoutMode) layout, height = \(calculatedHeight)")
#endif

            caches.estimatedHeights[id] = calculatedHeight
            return calculatedHeight
        }

        return 0
    }

    func retrieveCachedCell(_ tableView: UITableView, forRow indexPath: IndexPath) -> VIPERCellCache? {
        guard let (id, nib) = handler.cellInfo(table: self, at: indexPath) else {
            return nil
        }

        var cache: VIPERCellCache? = caches.cachedCell[id]
        if cache == nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: nib) as? VIPERTableCellViewBase {
                cache = VIPERCellCache(
                    cell: cell
                )
                caches.cachedCell[id] = cache
            }
        }

        return cache
    }
}

extension VIPERTableData where DataSource: SingleType {

    public convenience init(dataSource: DataSource, options: VIPERTableOptions = VIPERTableOptions()) {
        self.init(dataSource: dataSource, handler: SingleTypeHandler(dataSource), options: options)
    }
}

extension VIPERTableData where DataSource: MixedType {

    public convenience init(dataSource: DataSource, options: VIPERTableOptions = VIPERTableOptions()) {
        self.init(dataSource: dataSource, handler: MixedTypeHandler(dataSource), options: options)
    }
}
