//
//  ParallelCorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/20/16.
//
//

import Foundation

public final class ParallelCorpusReader  : Sequence, IteratorProtocol {

    public typealias SentenceTuple = ([String], [String])

    private let fReader, eReader: TokenCorpusReader

    public init?(fromFFile fPath: String, fromEFile ePath: String,
                sentenceSeparator separator: String = "\n",
                encoding: String.Encoding = .utf8,
                tokenizingWith tokenize: @escaping (String) -> [String] = ^String.tokenized) {
        guard let f = TokenCorpusReader(fromFile: fPath,
                                        sentenceSeparator: separator,
                                        encoding: encoding,
                                        tokenizingWith: tokenize),
                  let e = TokenCorpusReader(fromFile: ePath,
                                        sentenceSeparator: separator,
                                        encoding: encoding,
                                        tokenizingWith: tokenize) else { return nil }
        fReader = f
        eReader = e
    }



    public func rewind() {
        fReader.rewind()
        eReader.rewind()
    }

    public typealias Element = SentenceTuple

    public func next() -> Element? {
        guard let fNext = fReader.next(), let eNext = eReader.next() else {
            return nil
        }
        return (fNext, eNext)
    }

    public typealias Iterator = ParallelCorpusReader

    public func makeIterator() -> Iterator {
        rewind()
        return self
    }

}
