//: Playground - noun: a place where people can play

import PlaygroundSupport
import SwiftVIPER
import UIKit

class MyPresenter: VIPERPresenter {
    
}

class MyViewBinding: VIPERViewBinding {
    
    var presenter: MyPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = assemble(MyPresenter.self) { _ in
            return MyPresenter()    
        }
    }
}

class MyController: UIViewController {
    
    var binding = MyViewBinding()
    
    override func loadView() {
        super.loadView()
        self.bindings = [binding]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchViewDidLoad()
        
        assert(binding.presenter != nil)
        binding.presenter?.router.performRouting(Intent(data: nil))
    }
}

let controller = MyController()
PlaygroundPage.current.liveView = UINavigationController(rootViewController: controller)
