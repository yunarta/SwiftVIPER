//: Playground - noun: a place where people can play

import PlaygroundSupport
import Playground
import SwiftVIPER
import UIKit

let bundle: Bundle = Bundle(for: Playground.Bootstrap.self)
let ui = UIStoryboard(name: "RoutingDemo", bundle: bundle).instantiateInitialViewController()

PlaygroundPage.current.liveView = ui
