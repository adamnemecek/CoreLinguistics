//
//  Functional.swift
//  LangKit
//
//  Created by Richard Wei on 4/15/16.
//
//  This is a compact functional tool set.
//  The purpose of these functional tools is not to demonstrate the mathematical
//  abstraction, but to provide higher-order chaining semantics and express the
//  program logic clearly.
//

/// Operators
infix  operator |>  { associativity left  } // Feed to function
infix  operator <|  { associativity left  } // Reverse feed
infix  operator •   { associativity right } // Functional composition (math notation)
infix  operator >>- { associativity left  } // Monad bind (Haskell notation revised)
infix  operator -<< { associativity right } // Reverse monad bind (Haskell notation revised)
infix  operator >-> { associativity left  } // Monad composition (Haskell notation)
infix  operator <*> { associativity left  } // Applicative apply (Haskell notation)
infix  operator <^> { associativity left  } // Functor map (Haskell notation)

/// Identity function
@inline(__always)
public func identity<T>(x: T) -> T {
    return x
}

/// Curry
// ((a, b) -> c) -> a -> b -> c
@inline(__always)
public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}
// ((a, b, c) -> d) -> a -> b -> c -> d
@inline(__always)
public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { x in { y in { z in f(x, y, z) } } }
}

/// Uncurry
// (a -> b -> c) -> (a, b) -> c
@inline(__always)
public func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
    return { (x, y) in f(x)(y) }
}
// (a -> b -> c -> d) -> (a, b, c) -> d
@inline(__always)
public func uncurry<A, B, C, D>(_ f: @escaping (A) -> (B) -> (C) -> D) -> (A, B, C) -> D {
    return { (x, y, z) in f(x)(y)(z) }
}

/// Pipeline
// Reverse function application
@inline(__always)
public func |><A, B>(lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}
// Function application
@inline(__always)
public func <|<A, B>(lhs: (A) -> B, rhs: A) -> B {
    return lhs(rhs)
}

/// Compose
// f(x) • g(x) = f(g(x))
@inline(__always)
public func •<A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { f(g($0)) }
}
// f(x, y) • g(x) = f(g(x), g(y))
@inline(__always)
public func •<A, B, C>(f: @escaping (B, B) -> C, g: @escaping (A) -> B) -> (A, A) -> C {
    return { f(g($0), g($1)) }
}
// f(x, y) • g(x) = f(x, g(y))
@inline(__always)
public func •<A, B, C>(f: @escaping (B, B) -> C, g: @escaping (A) -> B) -> (B, A) -> C {
    return { f($0, g($1)) }
}
// f(x, y) • g(x) = f(g(x), y)
@inline(__always)
public func •<A, B, C>(f: @escaping (B, B) -> C, g: @escaping (A) -> B) -> (A, B) -> C {
    return { f(g($0), $1) }
}

/// Monad - Compose
// Optional
@inline(__always)
public func >-><A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C?) -> (A) -> C? {
    return { f($0) >>- g }
}
// Sequence
@inline(__always)
public func >-><A, B, C, MB: Sequence, MC: Sequence>
    (f: @escaping (A) -> MB, g: @escaping (B) -> MC) -> (A) -> [C]  where MB.Iterator.Element == B, MC.Iterator.Element == C {
    return { f($0).flatMap(g) }
}

/// Monad - Bind
// Optional
@inline(__always)
public func >>-<A, B>(lhs: A?, rhs: (A) -> B?) -> B? {
    return lhs.flatMap(rhs)
}
@inline(__always)
public func -<<<A, B>(lhs: (A) -> B?, rhs: A?) -> B? {
    return rhs.flatMap(lhs)
}
// Sequence
@inline(__always)
public func >>-<A, B, MA: Sequence>(lhs: MA, rhs: (A) -> [B]) -> [B] where MA.Iterator.Element == A {
    return lhs.flatMap(rhs)
}
@inline(__always)
public func -<<<A, B, MA: Sequence>(lhs: (A) -> [B], rhs: MA) -> [B]  where MA.Iterator.Element == A {
    return rhs.flatMap(lhs)
}

/// Applicative - Apply
// Optional
@inline(__always)
public func <*><A, B>(lhs: ((A) -> B)?, rhs: A?) -> B? {
    return lhs.flatMap{f in rhs.map(f)}
}
// Sequence
@inline(__always)
public func <*><A, B, FAB: Sequence, FA: Sequence>(lhs: FAB, rhs: FA) -> [B] where FAB.Iterator.Element == ((A) -> B), FA.Iterator.Element == A {
    return lhs.flatMap{f in rhs.map(f)}
}

/// Functor - Map
// Optional
@inline(__always)
public func <^><A, B>(lhs: (A) -> B, rhs: A?) -> B? {
    return rhs.map(lhs)
}
// Sequence
@inline(__always)
public func <^><A, B, FA: Sequence>(lhs: (A) -> B, rhs: FA) -> [B] where FA.Iterator.Element == A {
    return rhs.map(lhs)
}
