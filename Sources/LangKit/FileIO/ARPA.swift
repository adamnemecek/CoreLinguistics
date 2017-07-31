//
//  ARPA.swift
//  LangKit
//
//  Created by Richard Wei on 4/12/16.
//
//

import Foundation

public extension NgramModel {

    public func writeARPA(toFile path: String, encoding: String.Encoding = .utf8) {
        guard let file = FileHandle(forWritingAtPath: path) else {
            return
        }
        let header = "\\data\\\n"
        file.write(header.data(using: encoding)!)
        // FIXME!
        file.closeFile()
    }

}
