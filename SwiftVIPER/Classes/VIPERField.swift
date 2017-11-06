//
// Created by Yunarta Kartawahyudi on 6/11/17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import Foundation

public class VIPERField<T> {

    var observer: [(T) -> Void]? = [(T) -> Void]()

    public var value: T {
        didSet {
            observer?.forEach { closure in
                closure(value)
            }
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func onChange(_ closure: @escaping (T) -> Void) {
        observer?.append(closure)
        closure(value)
    }

    deinit {
        observer = nil
    }
}

public class VIPEROptionalField<T> {

    var observer: [(T) -> Void]? = [(T) -> Void]()

    var nilObserver: [() -> Void]? = [() -> Void]()

    public var value: T? {
        didSet {
            if let value = value {
                observer?.forEach { closure in
                    closure(value)
                }
            } else {
                nilObserver?.forEach { closure in
                    closure()
                }
            }

        }
    }

    public init(_ value: T?) {
        self.value = value
    }

    public func onChange(next: @escaping (T) -> Void, nullified: (() -> Void)? = nil) {
        observer?.append(next)
        if let nullified = nullified {
            nilObserver?.append(nullified)
        }

        if let value = value {
            next(value)
        } else {
            nullified?()
        }
    }

    deinit {
        observer = nil
        nilObserver = nil
    }
}