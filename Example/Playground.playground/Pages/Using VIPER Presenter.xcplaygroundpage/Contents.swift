//: Playground - noun: a place where people can play

import PlaygroundSupport
import SwiftVIPER
import RxSwift
import UIKit

struct Data {
    
    var text: String
    
    var value: Int
}

//: View binding is the "V" in VIPER, where all the view related function are executed here
class MyViewBinding: VIPERViewBinding, VIPERViewBindingInterface {
    
    weak var button: UIButton? {
        didSet {
            button?.addTarget(self, action: #selector(MyViewBinding.update), for: UIControlEvents.touchUpInside)
        }
    }
    
    weak var label: UILabel?
    
    var presenter: CountingPresenter?
    
    var disposable: Disposable?
    
    @objc required override init() {
        super.init()
    }
    
    @objc func update() {
        disposable?.dispose()
        disposable = presenter?.timer.subscribe(onNext: { [weak self] data in
            self?.label?.text = "\(data.text) \(data.value)"
        })
    }
}

//: The presenter starts here
class CountingPresenter: VIPERPresenter {
    
    let timer: Observable<Data>
    
    init() {
        timer = Observable<Int>.timer(0, period: 1, scheduler: ConcurrentMainScheduler.instance).map { value in
            return Data(text: "C", value: value)
        }
    }
}

//: Root view controller
class MyController: UIViewController {
    
    var binding = MyViewBinding()
    
    override func loadView() {
        super.loadView()
        
        binding.presenter = CountingPresenter()
        
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
        dispatchViewDidLoad()
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: MyController())


