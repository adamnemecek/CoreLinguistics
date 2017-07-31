//
//  Trie.swift
//  LangKit
//
//  Created by Richard Wei on 4/3/16.
//
//

/// Trie data structure (immutable)
///
/// - Leaf: (key, count)
/// - Node: (key, count, children)
public enum Trie<K: Hashable>: Equatable {

    case leaf(K?, Int)
    indirect case node(K?, Int, [K: Trie<K>])

    public init(initial: [K]? = nil) {
        let base = Trie.leaf(nil, 0)
        self = initial == nil ? base : base.insert(initial!)
    }

// MARK: - Equatable conformance


/// Equate two tries
/// 
/// - parameter lhs: Trie
/// - parameter rhs: Trie
/// 
/// - returns: Equal or not
    static public func ==(lhs: Trie, rhs: Trie) -> Bool {
        switch (lhs, rhs) {
        case let (.leaf(k1, v1), .leaf(k2, v2)):
            return k1 == k2 && v1 == v2
        case let (.node(k1, v1, c1), .node(k2, v2, c2)):
            return k1 == k2 && v1 == v2 && c1 == c2
        default:
            return false
        }
    }
}



// MARK: - Insertion
public extension Trie {

    /// Return a new trie with an item sequence inserted
    ///
    /// - parameter item: item sequence
    ///
    /// - returns: New trie after insertion
    public func insert(_ item: [K], incrementingNodes incr: Bool = false) -> Trie<K> {
        switch self {

        // Base cases
        case let .leaf(k, v) where item.isEmpty:
            return .leaf(k, v + 1)

        case let .node(k, v, children) where item.isEmpty:
            return .node(k, v + 1, children)

        // Leaf
        case let .leaf(k, v):
            let nk = item.first!
            let child = Trie.leaf(nk, 0).insert(Array(item.dropFirst()), incrementingNodes: incr)
            return .node(k, incr ? v + 1 : v, [nk : child])

        // Node
        case .node(let k, let v, var children):
            let nk = item.first!
            let restItem = Array(item.dropFirst())
            // Child exists
            if let child = children[nk] {
                children[nk] = child.insert(restItem, incrementingNodes: incr)
            }
            // Child does not exist. Call insert on a new leaf
            else {
                children[nk] = Trie.leaf(nk, 0).insert(restItem, incrementingNodes: incr)
            }
            return .node(k, incr ? v + 1 : v, children)
        }

    }

    /// Match type of two tries
    ///
    /// - parameter lhs: Trie
    /// - parameter rhs: Trie
    ///
    /// - returns: Match or not
    public static func ~=(lhs: Trie, rhs: Trie) -> Bool {
        switch (lhs, rhs) {
        case (.leaf(_, _)   , .leaf(_, _)   ),
             (.node(_, _, _), .node(_, _, _)):
            return true
        default:
            return false
        }
    }

    /// Combine two tries
    ///
    /// - parameter lhs: Left trie
    /// - parameter rhs: Rigth trie
    ///
    /// - returns: New trie
    public static func +(lhs: Trie, rhs: Trie) -> Trie<K> {
        return lhs.unionLeft(rhs)
    }

}

// MARK: - Combination
public extension Trie {

    /// Returns a union of two tries
    ///
    /// - parameter other:            Other trie
    /// - parameter conflictResolver: Conflict resolving function
    ///
    /// - returns: New trie after union
    public func union(_ other: Trie, conflictResolver: (K, K) -> K?) -> Trie<K> {
        // TODO
        return self
    }

    /// Returns a union of two tries
    /// If there's a conflict, take the original (left)
    ///
    /// - parameter other: Other trie
    ///
    /// - returns: New trie after union
    public func unionLeft(_ other: Trie) -> Trie<K> {
        return union(other) {left, _ in left}
    }

    /// Returns a union of two tries
    /// If there's a conflict, take the new (right)
    ///
    /// - parameter other: Other trie
    ///
    /// - returns: New trie after union
    public func unionRight(_ other: Trie) -> Trie<K> {
        return union(other) {_, right in right}
    }

}

// MARK: - Predication and Cardinality
public extension Trie {

    /// Determine if the key exists in children
    ///
    /// - parameter key: Key
    ///
    /// - returns: Exists or not
    public func hasChild(_ key: K) -> Bool {
        guard case let .node(_, _, children) = self else {
            return false // Leaf has no children
        }
        return children.keys.contains(key)
    }

    /// Number of children
    public var childCount: Int {
        guard case let .node(_, _, children) = self else {
            return 0 // Leaf has no children
        }
        return children.count
    }

}

// MARK: - Calculation
public extension Trie {

    /// Count at current node or leaf
    public var count: Int {
        return self.count([])
    }

    /// Count item sequence
    ///
    /// - parameter item: Item sequence
    ///
    /// - returns: Count of sequence
    public func count(_ item: [K]) -> Int {
        switch self {
        // Base case
        case .leaf(_, let v):
            return item.isEmpty ? v : 0
        // Node
        case .node(_, let v, let children):
            if item.isEmpty {
                return v
            }
            let nk = item.first!
            guard let child = children[nk] else {
                return 0
            }
            return child.count(item.dropFirst().map{$0})
        }
    }

    /// Sum all leave counts
    ///
    /// - returns: Count
    public func sumLeaves() -> Int {
        switch self {
        case .leaf(_, let v):
            return v
        case .node(_, _, let children):
            let sums = children.values.map{ $0.sumLeaves() }
            return sums.reduce(0, +)
        }
    }

    /// Sum all counts
    ///
    /// - returns: Count
    public func sum() -> Int {
        switch self {
        case let .leaf(_, v):
            return v
        case let .node(_, v, children):
            let sums = children.values.map{$0.sum()}
            return v + sums.reduce(0, +)
        }
    }

}

