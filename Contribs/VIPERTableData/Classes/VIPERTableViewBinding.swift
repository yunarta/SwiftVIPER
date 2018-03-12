//
// Created by Yunarta Kartawahyudi on 5/11/17.
//

import UIKit

public typealias VIPERTableViewBindingOutlet = VIPERTableViewBinding & VIPERViewBindingInterface

open class VIPERTableViewBinding: VIPERViewBinding {
    
    weak var internalTableData: VIPERTable?

    public init(tableData: VIPERTable) {
        self.internalTableData = tableData
        super.init()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        assert(internalTableData != nil)
        
        internalTableData?.install(router: controller?.router, viewContext: viewContext)
    }
}
