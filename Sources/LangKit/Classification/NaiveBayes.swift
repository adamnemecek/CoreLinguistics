//
//  NaiveBayes.swift
//  LangKit
//
//  Created by Richard Wei on 3/22/16.
//
//

public struct NaiveBayes<Input, Label: Hashable> : Classifier {

    public typealias ProbabilityFunction = (Input) -> Float

    private var probabilityFunctions: [Label: ProbabilityFunction] = [:]

    public var classes: [Label] {
        return Array(probabilityFunctions.keys)
    }

    public var flipped: Bool

    public init(probabilityFunctions probFuncs: [Label: ProbabilityFunction], flipped: Bool = false) {
        self.probabilityFunctions = probFuncs
        self.flipped = flipped
    }

    public init<T: LanguageModel>(languageModels: [Label: T], flipped: Bool = false) where T.Sentence == Input {
        var lms: [Label: ProbabilityFunction] = [:]
        languageModels.forEach { lms[$0] = $1.sentenceLogProbability }
        self.init(probabilityFunctions: lms, flipped: flipped)
    }



    public mutating func add(classLabel: Label, probabilityFunction probFunc: @escaping ProbabilityFunction) {
        if !probabilityFunctions.keys.contains(classLabel)  {
            probabilityFunctions[classLabel] = probFunc
        }
    }


    public func classify(_ input: Input) -> Label? {
        return (flipped ? argmin : argmax)(Array(probabilityFunctions.keys)) {
            self.probabilityFunctions[$0]!(input)
        }
    }

}
