//: Playground - noun: a place where people can play

import PlaygroundSupport
import SwiftVIPER
import UIKit

//: Defining view interface protocol allow you to change implementation of the view later
protocol MyViewInterface: class {
    
    var state: (String, Int) { get set }
}

//: Actual implementation of the view interface
class MyView: MyViewInterface, VIPERViewInterface {
    
    let observableState = VIPERField<(String, Int)>(("A", 0))
    var state: (String, Int) {
        get {
            return observableState.value
        }
        
        set {
            observableState.value = newValue
        }
    }
}

//: View binding is the "V" in VIPER, where all the view related function are executed here
class MyViewBinding: VIPERViewBinding, VIPERViewBindingInterface {
    
    weak var button: UIButton? {
        didSet {
            button?.addTarget(self, action: #selector(MyViewBinding.update), for: UIControlEvents.touchUpInside)
        }
    }
    
    weak var label: UILabel? {
        didSet {
            view.observableState.onChange { [weak self] (prefix, number) in
                self?.label?.text = "\(prefix) \(number)"
            }
        }
    }
    
    var view = MyView()
    
    @objc required init() {
        super.init(view: view)
    }
    
    @objc func update() {
        let number = view.state.1 + 1
        view.state = (view.state.0, number)
    }
}

//: The presenter starts here
class CountingPresenter: VIPERPresenter {
    
    weak var view: MyViewInterface?
    
    var timer: Timer?
    
    var counter = 0
    
    init(_ view: MyViewInterface) {
        self.view = view
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let me = self else {
                return
            }
            
            me.view?.state = ("C", me.counter)
            me.counter += 1
        }
    }
}

//: Root view controller
class MyController: UIViewController {

    var binding = MyViewBinding()
    
    override func loadView() {
        super.loadView()
        
        let view = UIView()
        view.backgroundColor = .white

        let button = UIButton()
        button.frame = CGRect(x: 16, y: 60, width: 200, height: 32)
        button.setTitle("Increment", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue

        view.addSubview(button)

        let label = UILabel()
        label.frame = CGRect(x: 16, y: 108, width: 200, height: 32)
  
        view.addSubview(label)
        self.view = view
        
        binding.button = button
        binding.label = label
        
        self.bindings = [binding]
    }

    override func viewDidLoad() {
        navigationItem.title = "Root"
        presenters.set(name: "counter", CountingPresenter(binding.view))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let presenter = presenters.get(name: "counter") as? CountingPresenter {
            presenter.start()
        }
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: MyController())

