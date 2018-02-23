//: Playground - noun: a place where people can play
/*:
Demonstrate that with view and presenter model we can test the presenter output independently wihout user interface test.
Assuming the view test in the user interface test behave as expected.
*/

import PlaygroundSupport
import SwiftVIPER
import UIKit

//: Defining view interface protocol allow you to change implementation of the view later
protocol MyViewInterface: class {
    
    var state: (String, Int) { get set }
}

//: Actual implementation of the view interface
class MyView: MyViewInterface, VIPERViewInterface {
    
    var state: (String, Int) = ("", 0)
}

//: The presenter starts here
class CountingPresenter: VIPERPresenter {
    
    weak var view: MyViewInterface?
    
    var timer: Timer?
    
    var counter = 0
    
    init(_ view: MyViewInterface) {
        self.view = view
    }
    
    func update() {
        view?.state = ("C", counter)
        counter += 1
    }
}

let view = MyView()

let presenter = CountingPresenter(view)
presenter.update()

assert(view.state.0 == "C")
assert(view.state.1 == 0)
