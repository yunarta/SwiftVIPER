//
//  VIPERTableData.swift
//  SwiftVIPER
//
//  Created by Yunarta Kartawahyudi on 28/2/18.
//

import Foundation

protocol DataSourceHandler {
    
    var dataSource: VIPERTableDataSource? { get }
    
    func creationInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo?
}

class SingleTypeHandler<S>: DataSourceHandler where S: VIPERTableDataSource & SingleType {
    
    var dataSource: VIPERTableDataSource? {
        return singleType
    }
    
    weak var singleType: S?
    
    init(_ dataSource: S) {
        self.singleType = dataSource
    }
    
    func creationInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo? {
        return singleType?.creationInfo(table: table)
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
    
    func creationInfo(table: VIPERTable, at indexPath: IndexPath) -> CellCreationInfo? {
        return mixedType?.creationInfo(table: table, at: indexPath)
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
    
    public init() {
        
    }
}

open class VIPERTableData<DataSource>: NSObject, VIPERTable, UITableViewDataSource, UITableViewDelegate where DataSource: VIPERTableDataSource {
    
    var dataSource: DataSource
    
    var handler: DataSourceHandler
    
    var options: VIPERTableOptions
    
    // MARK: - Cell caching
    
    let caches = VIPERTableCache()
    
    // MARK: - Init
    
    init(dataSource: DataSource, handler: DataSourceHandler, options: VIPERTableOptions) {
        self.dataSource = dataSource
        self.handler = handler
        self.options = options
        
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.table(table: self, numberOfRowsInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let (id, nib) = handler.creationInfo(table: self, at: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: nib) {
            if let cell = cell as? VIPERTableCellViewBase {
                let context = cell.context
                
                context.indexPath = indexPath
                if context.isNeedConfiguration {
                    cell.configureContext(from: dataSource)
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
        if var inUse: VIPERTableCellViewBase = caches.inUse[indexKey] {
            // we are being called after cell acquisition
            if let height = caches.cachedHeights[indexKey] {
                if inUse.layoutMode == .autoLayout {
                    // for auto layout cell, we use the available height
                    return height
                } else if inUse.isContentChanged == false {
                    // for manual layout cell, the content has not been changed, we use the available height
                    return height
                }
            }
            
            // populate cell with real data
            dataSource.present(table: self, cell: inUse, at: indexPath)
            
            let calculatedHeight: CGFloat
            switch inUse.layoutMode {
            case .autoLayout:
                let layoutView = inUse.layoutView ?? inUse.contentView
                let layoutSize: CGSize = VIPERTableData.systemLayoutFitting(layoutView, width: tableView.frame.width)
                
                calculatedHeight = layoutSize.height + separatorHeight
                
            case .manualLayout:
                // for manual cell, we will recalculate the height if the content has changed
                let layoutSize: CGSize = inUse.computeLayoutSize()
                inUse.isContentChanged = false
                
                calculatedHeight = layoutSize.height + separatorHeight
            }
            
            caches.cachedHeights[indexKey] = calculatedHeight
            return calculatedHeight
        } else {
            // we are being called for content size and scroll estimation
            if let cached: VIPERCellCache = retrieveCachedCell(tableView, forRow: indexPath) {
                var cell: VIPERTableCellViewBase = cached.cell
                
                // populate cell with real data
                dataSource.present(table: self, cell: cell, at: indexPath)
                
                let calculatedHeight: CGFloat
                switch cell.layoutMode {
                case .autoLayout:
                    let layoutView = cell.layoutView ?? cell.contentView
                    let layoutSize: CGSize = VIPERTableData.systemLayoutFitting(layoutView, width: tableView.frame.width)
                    
                    calculatedHeight = layoutSize.height + separatorHeight
                    
                case .manualLayout:
                    // for manual cell, we will recalculate the height if the content has changed
                    let layoutSize: CGSize = cell.estimateLayoutSize() 
                    cell.isContentChanged = false
                    
                    calculatedHeight = layoutSize.height + separatorHeight
                }
                
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
        
        guard let (id, _) = handler.creationInfo(table: self, at: indexPath) else {
            return 0
        }
        
        // let indexKey: Int = indexPath.section * 10_000 + indexPath.row
        let separatorHeight: CGFloat = tableView.separatorStyle == .none ? 0.0 : 1.0
        
        if let estimated = caches.estimatedHeights[id] {
            return estimated
        }
        
        // we are being called for content size and scroll estimation
        if let cached: VIPERCellCache = retrieveCachedCell(tableView, forRow: indexPath) {
            var cell: VIPERTableCellViewBase = cached.cell
            
            let calculatedHeight: CGFloat
            switch cell.layoutMode {
            case .autoLayout:
                let layoutView = cell.layoutView ?? cell.contentView
                let layoutSize: CGSize = VIPERTableData.systemLayoutFitting(layoutView, width: tableView.frame.width)
                
                calculatedHeight = layoutSize.height + separatorHeight
                
            case .manualLayout:
                // for manual cell, we will recalculate the height if the content has changed
                let layoutSize: CGSize = cell.estimateLayoutSize()
                cell.isContentChanged = false
                
                calculatedHeight = layoutSize.height + separatorHeight
            }
            
            caches.estimatedHeights[id] = calculatedHeight
            return calculatedHeight
        }
        
        return 0
    }
    
    func retrieveCachedCell(_ tableView: UITableView, forRow indexPath: IndexPath) -> VIPERCellCache? {
        guard let (id, nib) = handler.creationInfo(table: self, at: indexPath) else {
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
    
    class func systemLayoutFitting(_ view: UIView, width: CGFloat) -> CGSize {
        return view.systemLayoutSizeFitting(CGSize(width: width, height: 0),
                                            withHorizontalFittingPriority: UILayoutPriority.required,
                                            verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
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
