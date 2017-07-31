//
//  Key.swift
//  LangKit
//
//  Created by Richard Wei on 4/13/16.
//
//


public struct ArrayKey<Element: Hashable> : Hashable, ExpressibleByArrayLiteral {

    private let elements: [Element]

    public let hashValue: Int

    public init(arrayLiteral elements: Element...) {
        self.elements = elements
        hashValue = elements.reduce(0) { acc, x in
            31 &* acc.hashValue &+ x.hashValue
        }
    }

    public subscript(index: Int) -> Element {
        return elements[index]
    }

    public static func ==(lhs: ArrayKey, rhs: ArrayKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}
