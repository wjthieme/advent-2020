//
//  09.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day9a: Solve = { input in
        let values = processInput(input)
        let firstInvalid = firstInvalidNumber(in: values, preamble: 25)
        return "\(firstInvalid)"
    }
    
    @objc static let day9b: Solve = { input in
        let values = processInput(input)
        let invalid = firstInvalidNumber(in: values, preamble: 25)
        let contigousValue = invalidSet(in: values, invalidNum: invalid)
        return "\(contigousValue)"
    }
}

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: "\n")
    return lines.compactMap { Int($0) }
}

fileprivate func firstInvalidNumber(in values: [Int], preamble: Int) -> Int {
    for (offset, value) in values.enumerated() {
        if offset < preamble { continue }
        let previous = Set(values[offset-preamble..<offset])
        let remainder = previous.map { value - $0 }
        if !remainder.contains(where: { previous.contains($0) }) { return value }
    }
    return 0
}

fileprivate func invalidSet(in values: [Int], invalidNum: Int) -> Int {
    for offset in 0..<values.count {
        for x in 2...25 {
            if offset + x >= values.count { continue }
            let range = values[offset..<offset+x]
            if range.reduce(0, +) != invalidNum { continue }
            guard let min = range.min() else { continue }
            guard let max = range.max() else { continue }
            return min + max
        }
    }
    return 0

}


