//
//  RoutingDemo.swift
//  Playground
//
//  Created by Yunarta Kartawahyudi on 22/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import SwiftVIPER
import UIKit

class RootRouting: NSObject, VIPERRouting {

    override init() {
        super.init()
    }
    
    public func willPerformRouting(_ controller: UIViewController, intent: Intent) -> Bool {
        return IntentRouter { _ in
            return false
        }.addRoute(authority: "application", path: "/one") { (intent) -> Bool in
            if let page = controller.storyboard?.instantiateViewController(withIdentifier: "PageOne") {
                controller.navigationController?.pushViewController(page, animated: true)
            }
            return true
        }.addRoute(authority: "application", path: "/two") { (intent) -> Bool in
            if let page = controller.storyboard?.instantiateViewController(withIdentifier: "PageTwo") {
                controller.navigationController?.pushViewController(page, animated: true)
            }
            return true
        }.match(intent)
    }
}

class RootViewController: UIViewController {

    @IBAction func openPageOne(_ sender: Any) {
        performRouting(Intent(data: URL(string: "http://application/one")))
    }

    @IBAction func openPageTwo(_ sender: Any) {
        performRouting(Intent(data: URL(string: "http://application/two")))
    }
}
