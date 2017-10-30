//
// Created by Yunarta Kartawahyudi on 6/10/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if os(macOS)
    public typealias PlatformViewController = NSViewController
#else
    public typealias PlatformViewController = UIViewController
#endif
