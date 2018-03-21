//: Playground - noun: a place where people can play

import PlaygroundSupport
import SwiftVIPER
import UIKit

//: Dialog with close button

class Dialog: UIViewController {

    override func loadView() {
        super.loadView()
        routing = RootRouting()

        let view = UIView()
        view.backgroundColor = .white

        let button1 = UIButton()
        button1.frame = CGRect(x: 16, y: 60, width: 200, height: 32)
        button1.setTitle("Close", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.backgroundColor = UIColor.blue
        button1.addTarget(self, action: #selector(Dialog.close), for: UIControlEvents.touchUpInside)

        view.addSubview(button1)
        self.view = view
    }

    @objc func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//: Base page view with open dialog button

class Page: UIViewController {

    override func loadView() {
        super.loadView()
        routing = RootRouting()

        let view = UIView()
        view.backgroundColor = .white

        let button1 = UIButton()
        button1.frame = CGRect(x: 16, y: 60, width: 200, height: 32)
        button1.setTitle("Open Dialog", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.backgroundColor = UIColor.blue
        button1.addTarget(self, action: #selector(Page.openDialog), for: UIControlEvents.touchUpInside)

        view.addSubview(button1)
        self.view = view
    }

    @objc func openDialog(_ sender: Any) {
        performRouting(Intent(data: URL(string: "http://application/dialog")))
    }
}

class PageOne: Page {

    override func viewDidLoad() {
        navigationItem.title = "Page One"
    }
}

class PageTwo: Page {

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
            return false-
            }.addRoute(authority: "application", path: "/one") { (_) -> Bool in
                controller.navigationController?.pushViewController(PageOne(), animated: true)
                return true
            }.addRoute(authority: "application", path: "/two") { (_) -> Bool in
                controller.navigationController?.pushViewController(PageTwo(), animated: true)
                return true
            }.addRoute(authority: "application", path: "/dialog") { (_) -> Bool in
                controller.present(Dialog(), animated: true, completion: nil)
                return true
            }.match(intent)
    }
}

//: Root view controller
class MyViewController: UIViewController {

    override func loadView() {
        super.loadView()
        //: the routing is installed only in the root

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
