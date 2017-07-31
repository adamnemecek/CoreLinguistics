//
//  LineReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/27/16.
//
//

import Foundation

public final class LineReader : IteratorProtocol, Sequence {

    // Chunk size constant
    private let chunkSize = 4096

    private let path: String
    private let encoding: String.Encoding
    private let lineSeparator: String
    private let fileHandle: FileHandle
    private let buffer: NSMutableData
    private let delimiterData: NSData

    // EOF state
    private var eof: Bool = false

    /// Initialize a LineReader with configurations
    ///
    /// - parameter fromFile:          File path
    /// - parameter lineSeparator:     Line separator (default: "\n")
    /// - parameter encoding:          File encoding (default: UTF-8)
    public required init?(fromFile path: String, lineSeparator: String = "\n",
                          encoding: String.Encoding = .utf8) {
        guard let handle = FileHandle(forReadingAtPath: path),
                  let delimiterData = lineSeparator.data(using: encoding),
                  let buffer = NSMutableData(capacity: chunkSize) else {
            return nil
        }
        self.path = path
        self.encoding = encoding
        self.lineSeparator = lineSeparator
        self.fileHandle = handle
        self.buffer = buffer
        self.delimiterData = delimiterData as NSData
    }

    deinit {
        self.close()
    }

    /// Close file
    func close() {
        fileHandle.closeFile()
    }

    /// Go to the beginning of the file
    public func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        eof = false
    }

    public typealias Element = String

    /// Next line
    ///
    /// - returns: Line
    public func next() -> Element? {
        if eof {
            return nil
        }

        var range = buffer.range(of: delimiterData as Data, options: [], in: NSMakeRange(0, buffer.length))

        while range.location == NSNotFound {
            let data = fileHandle.readData(ofLength: chunkSize)
            guard data.count > 0 else {
                eof = true
                return nil
            }

            buffer.append(data)
            range = buffer.range(of: delimiterData as Data, options: [], in: NSMakeRange(0, buffer.length))
        }

        let line = String(data: buffer.subdata(with: NSMakeRange(0, range.location)), encoding: encoding)
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)

        return line
    }





    public typealias Iterator = LineReader

    /// Make line iterator
    ///
    /// - returns: Iterator
    public func makeIterator() -> Iterator {
        self.rewind()
        return self
    }
    
}
