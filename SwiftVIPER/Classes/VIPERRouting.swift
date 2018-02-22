//
// Created by Yunarta Kartawahyudi on 4/10/17.
// Copyright (c) 2017 Yunarta Kartawahyudi. All rights reserved.
//

import Foundation

public class GenericURLMatcher<MatchResult> {

    enum RouteMatcherType {
        case none, exact, number, text
    }

    class Matcher<MatchResult> {

        var which: RouteMatcherType = .none

        var text: String = ""

        var children = [Matcher]()

        var action: MatchResult

        init(action: MatchResult) {
            self.action = action
        }
    }

    var root: Matcher<MatchResult>

    public init(_ `default`: MatchResult) {
        root = Matcher<MatchResult>(action: `default`)
    }

    public func addRoute(authority: String, path: String, result: MatchResult) -> Self {
        var newPath = path
        if newPath.count > 0, newPath.starts(with: "/") {
            newPath.removeFirst()
        }

        let tokens = newPath.components(separatedBy: "/")
        let numTokens = tokens.count

        var node = root
        for i in -1..<numTokens {
            let token = i < 0 ? authority : tokens[i]

            let children = node.children
            let numChildren = children.count

            var foundNode = false
            for j in 0..<numChildren {
                let child = children[j]
                if token == child.text {
                    node = child
                    foundNode = j + 1 == numChildren
                    break
                }
            }

            if !foundNode {
                // Child not found, create it
                let child = Matcher(action: result)
                switch token {
                case "#":
                    child.which = .number

                case "*":
                    child.which = .text

                default:
                    child.which = .exact
                }

                child.text = token

                node.children.append(child)
                node = child
            }
        }

        return self
    }

    public func match(_ url: URL) -> MatchResult {
        let pathSegments = url.pathComponents
        let li = pathSegments.count - 1

        var node: Matcher? = root
        for i in -1..<li {
            guard let u: String = i < 0 ? url.host : pathSegments[i + 1] else {
                return root.action
            }

            guard let list = node?.children else {
                break
            }

            node = nil
            let lj = list.count
            for j in 0..<lj {
                let n = list[j]

                which_switch: switch n.which {
                case .exact:
                    if n.text == u {
                        node = n
                        break
                    }

                case .number:
                    let lk = u.count
                    for k in 0..<lk {
                        let c = u[k]
                        if c < "0" || c > "9" {
                            break which_switch
                        }
                    }
                    node = n

                case .text:
                    node = n

                case .none:
                    break
                }

                if node != nil {
                    break
                }
            }

            if node == nil {
                return root.action
            }
        }

        return node?.action ?? root.action
    }
}

public class IntentRouter {

    let matcher: GenericURLMatcher<(Intent) -> Bool>

    public init(_ `default`: @escaping (Intent) -> Bool) {
        matcher = GenericURLMatcher<(Intent) -> Bool>(`default`)
    }

    public convenience init() {
        self.init { (intent) -> Bool in
            return false
        }
    }

    public func addRoute(authority: String, path: String, action: @escaping (Intent) -> Bool) -> Self {
        _ = matcher.addRoute(authority: authority, path: path, result: action)
        return self
    }
    
    public func match(_ intent: Intent) -> Bool {
        guard let url = intent.data else {
            return false
        }
        
        let result = matcher.match(url)
        return result(intent)
    }
}

extension String {

    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
