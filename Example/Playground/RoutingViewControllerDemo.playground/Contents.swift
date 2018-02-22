//: Playground - noun: a place where people can play

import PlaygroundSupport
import SwiftVIPER
import UIKit

class PageOne: UIViewController {

    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }

    override func viewDidLoad() {
        navigationItem.title = "Page One"
    }
}

class PageTwo: UIViewController {

    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }

    override func viewDidLoad() {
        navigationItem.title = "Page Two"
    }
}

class RootRouting: NSObject, VIPERRouting {

    override init() {
        super.init()
    }

    public func willPerformRouting(_ controller: UIViewController, intent: Intent) -> Bool {
        return IntentRouter { _ in
            return false
        }.addRoute(authority: "application", path: "/one") { (intent) -> Bool in
            controller.navigationController?.pushViewController(PageOne(), animated: true)
            return true
        }.addRoute(authority: "application", path: "/two") { (intent) -> Bool in
            controller.navigationController?.pushViewController(PageTwo(), animated: true)
            return true
        }.match(intent)
    }
}

class MyViewController: UIViewController {

    override func loadView() {
        super.loadView()
        routing = RootRouting()

        let view = UIView()
        view.backgroundColor = .white

        let button1 = UIButton()
        button1.frame = CGRect(x: 16, y: 60, width: 200, height: 32)
        button1.setTitle("Open Page One", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.backgroundColor = UIColor.blue
        button1.addTarget(self, action: #selector(MyViewController.openPageOne), for: UIControlEvents.touchUpInside)

        view.addSubview(button1)

        let button2 = UIButton()
        button2.frame = CGRect(x: 16, y: 108, width: 200, height: 32)
        button2.setTitle("Open Page Two", for: .normal)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.backgroundColor = UIColor.blue
        button2.addTarget(self, action: #selector(MyViewController.openPageTwo), for: UIControlEvents.touchUpInside)

        view.addSubview(button2)
        self.view = view
    }

    override func viewDidLoad() {
        navigationItem.title = "Root"
    }

    @objc func openPageOne(_ sender: Any) {
        performRouting(Intent(data: URL(string: "http://application/one")))
    }

    @objc func openPageTwo(_ sender: Any) {
        performRouting(Intent(data: URL(string: "http://application/two")))
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: MyViewController())
