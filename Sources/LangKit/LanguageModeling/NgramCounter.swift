//
//  NgramCounter.swift
//  LangKit
//
//  Created by Richard Wei on 4/12/16.
//
//

public protocol NgramCounter {

    mutating func insert(ngram: [String])

    subscript(ngram: [String]) -> Int { get }

    var count: Int { get }

}

public struct TrieNgramCounter : NgramCounter {

    private var trie: Trie<String>

    public init() {
        trie = Trie()
    }

    public mutating func insert(ngram: [String]) {
        trie = trie.insert(ngram, incrementingNodes: true)
    }

    public subscript(ngram: [String]) -> Int {
        return trie.count(ngram)
    }

    public var count: Int {
        return trie.count
    }
    
}

private func ==(lhs: DictionaryNgramCounter.NgramKey, rhs: DictionaryNgramCounter.NgramKey) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public struct DictionaryNgramCounter : NgramCounter {

    private struct NgramKey: Hashable, Equatable  {

        let ngram: [String]

        init(_ ngram: [String]) {
            self.ngram = ngram
        }

        var hashValue: Int {
            return "\(ngram)".hashValue
        }

        var pregramKey: NgramKey {
            return .init(Array(ngram.dropLast()))
        }

    }

    private var table: [NgramKey: Int]
    private var backoffTable: [NgramKey: Int]

    public init(minimumCapacity capacity: Int) {
        table = .init(minimumCapacity: capacity)
        backoffTable = .init(minimumCapacity: capacity)
    }

    public init() {
        table = .init()
        backoffTable = .init()
    }

    public mutating func insert(ngram: [String]) {
        let key = NgramKey(ngram)
        table[key] = (table[key] ?? 0) + 1
        let pregramKey = key.pregramKey
        backoffTable[pregramKey] = (backoffTable[pregramKey] ?? 0) + 1
    }

    public subscript(ngram: [String]) -> Int {
        let key = NgramKey(ngram)
        return table[key] ?? backoffTable[key] ?? 0
    }

    public var count: Int {
        return table.count
    }


}