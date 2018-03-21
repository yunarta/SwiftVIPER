import SwiftVIPER
import UIKit

var matcher = IntentRouter { intent -> Bool in
    print("no matches found for \(intent.data!)")
    return false
}

matcher.addRoute(authority: "application", path: "/user/#") { intent -> Bool in
    print("found matches /user/# for \(intent.data!)")
    return true
    }.addRoute(authority: "application", path: "/user/#/detail") { intent -> Bool in
        print("found matches /user/#/detail for \(intent.data!)")
        return true
    }.addRoute(authority: "application", path: "/item/*") { intent -> Bool in
        print("found matches /user/#/detail for \(intent.data!))")
        return true
}

assert(matcher.match(Intent(data: URL(string: "content://application/user/1"))) == true)
assert(matcher.match(Intent(data: URL(string: "content://application/user/any"))) == false)

assert(matcher.match(Intent(data: URL(string: "content://application/user/1/detail"))) == true)
assert(matcher.match(Intent(data: URL(string: "content://application/user/any/detail"))) == false)

assert(matcher.match(Intent(data: URL(string: "content://application/item/1"))) == true)
assert(matcher.match(Intent(data: URL(string: "content://application/item/any"))) == true)
assert(matcher.match(Intent(data: URL(string: "content://application/item/any/unknown"))) == false)

assert(matcher.match(Intent(data: URL(string: "content://application/unknown"))) == false)
assert(matcher.match(Intent(data: URL(string: "content://application/unknown/1"))) == false)
