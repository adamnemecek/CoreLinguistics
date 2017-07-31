//
//  PartOfSpeechTagger.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

public final class PartOfSpeechTagger {

    let model: HiddenMarkovModel<String, String>

    ///	Initialize from tagged corpus
    public init<S: Sequence>(taggedCorpus corpus: S,
                 smoothingMode smoothing: SmoothingMode = .goodTuring) where S.Iterator.Element == [(String, String)] {
        model = HiddenMarkovModel(taggedCorpus: corpus, smoothingMode: smoothing, replacingItemsFewerThan: 0)
    }

}

extension PartOfSpeechTagger: Tagger {

    /// Tag a sequence
    ///
    /// - parameter sequence: Sequence of items [w0, w1, w2, ...]
    ///
    /// - returns: [(w0, t0), (w1, t1), (w2, t2), ...]
    public func tag(_ sequence: [String]) -> [(String, String)] {
        return model.tag(sequence)
    }

}
