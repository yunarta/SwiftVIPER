//
// Created by Yunarta Kartawahyudi on 5/11/17.
//

import UIKit

public typealias VIPERTableViewBindingOutlet = VIPERTableViewBinding & VIPERViewBindingInterface

open class VIPERTableViewBinding: VIPERViewBinding {

    weak var internalDataSource: VIPERTableDataSource?

    public init(view: VIPERViewInterface, dataSource: VIPERTableDataSource) {
        self.internalDataSource = dataSource
        super.init(view: view)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        assert(internalDataSource != nil)
    }
}
