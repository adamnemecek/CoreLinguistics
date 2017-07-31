//
//  Helpers.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

///	Force generate
/// Equivalent to .map{$0}


/// Instance method invocation closure
prefix operator ^ {}

/// Increment optional variable while unwrapping with default value if nil
infix operator ?+= {
    associativity right
    precedence 90
    assignment
}

/// Increment optional variable while force-unwrapping
infix operator !+= {
    associativity right
    precedence 90
    assignment
}

/// Instance method invoker
///
/// - parameter f: Uninstantiated instance method (A -> () -> B)
///
/// - returns: Uninstantiated method with auto invocation (A -> B)
@inline(__always)
public prefix func ^<A, B>(f: @escaping (A) -> () -> B) -> (A) -> B {
    return {f($0)()}
}

extension Integer {
    /// Increment while unwrapping with default value if nil
    ///
    /// - returns: Incremented value
    @inline(__always)
    public static func ?+=(lhs: inout Self?, rhs: Self) {
        lhs = rhs + (lhs ?? 0)
    }

    /// Increment while force-unwrapping
    ///
    /// - returns: Incremented value
    @inline(__always)
    public static func !+=(lhs: inout Self?, rhs: Self) {
        lhs = rhs + lhs!
    }
}

extension Float {

    @inline(__always)
    public static func !+=(lhs: inout Float?, rhs: Float) {
        lhs = rhs + lhs!
    }

    @inline(__always)
    public static func ?+=(lhs: inout Float?, rhs: Float) {
        lhs = rhs + (lhs ?? 0.0)
    }
}

extension Double {
    @inline(__always)
    public static func !+=(lhs: inout Double?, rhs: Double) {
        lhs = rhs + lhs!
    }

    @inline(__always)
    public static func ?+=(lhs: inout Double?, rhs: Double) {
        lhs = rhs + (lhs ?? 0.0)
    }

}
