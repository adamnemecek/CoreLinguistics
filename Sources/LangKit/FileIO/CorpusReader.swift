//
//  CorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/11/16.
//
//

import Foundation

/// Generic corpus reader of items
/// An Item is the smallest unit in a sentence, eg. a token
/// A corpus has form
///   [[Item, Item, Item, ...], [Item, Item, Item, ...], ...]
public class CorpusReader<Item> : IteratorProtocol {

    public typealias Sentence = [Item]

    // Tokenization function
    private var tokenize: (String) -> [Item]

    // Line reader
    public let reader: LineReader

    /// Initialize from file
    /// 
    /// - parameter fromFile:          File path
    /// - parameter sentenceSeparator: Sentence separator (default: "\n")
    /// - parameter encoding:          File encoding (default: UTF-8)
    /// - parameter tokenizingWith:    Tokenization function :: String -> [String] (default: String.tokenize)
    public required init?(fromFile path: String, sentenceSeparator: String = "\n",
                          encoding: String.Encoding = .utf8,
                          tokenizingWith tokenize: @escaping (String) -> [Item]) {
        guard let reader = LineReader(fromFile: path, lineSeparator: sentenceSeparator, encoding: encoding) else {
            return nil
        }
        self.reader = reader
        self.tokenize = tokenize
    }

    /// Go to the beginning of the file
    public func rewind() {
        reader.rewind()
    }



    public typealias Elememnt = Sentence

    /// Next tokenized sentence
    ///
    /// - returns: Tokenized sentence
    public func next() -> [Item]? {
        return reader.next() >>- tokenize
    }

}

extension CorpusReader : Sequence {

    public typealias Iterator = CorpusReader

    /// Make sentence iterator
    ///
    /// - returns: Iterator
    public func makeIterator() -> Iterator {
        rewind()
        return self
    }

}

public final class TokenCorpusReader : CorpusReader<String> {
    public typealias Item = String
    /// Initialize from file
    ///
    /// - parameter fromFile:          File path
    /// - parameter sentenceSeparator: Sentence separator (default: "\n")
    /// - parameter encoding:          File encoding (default: UTF-8)
    /// - parameter tokenizingWith:    Tokenization function :: String -> [String] (default: String.tokenize)
    public required init?(fromFile path: String,
                 sentenceSeparator: String = "\n",
                 encoding: String.Encoding = .utf8,
                 tokenizingWith tokenize: @escaping (String) -> [String] = ^String.tokenized) {
        super.init(fromFile: path, sentenceSeparator: sentenceSeparator, encoding: encoding, tokenizingWith: tokenize)
    }
  
}
