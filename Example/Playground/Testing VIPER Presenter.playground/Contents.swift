//: Playground - noun: a place where people can play
/*:
Demonstrate that with view and presenter model we can test the presenter output independently wihout user interface test.
Assuming the view test in the user interface test behave as expected.
*/

import PlaygroundSupport
import RxBlocking
import RxSwift
import SwiftVIPER
import UIKit

struct Data {
    
    var text: String
    
    var value: Int
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

let presenter = CountingPresenter()

if let data = try presenter.timer.toBlocking(timeout: 10).first() {
    assert(data.text == "C")
    assert(data.value == 0)
}
