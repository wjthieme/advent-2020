//
//  05.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day5a: Solve = { input in
        let values = processInput(input)
        let passes = values.compactMap { BoardingPass(code: $0) }
        let max = passes.max(by: { $0.id < $1.id })?.id ?? 0
        return "\(max)"
    }
    
    @objc static let day5b: Solve = { input in
        let values = processInput(input)
        let passes = values.compactMap { BoardingPass(code: $0) }
        let dict = passes.reduce(into: [:]) { $0[$1.id] = $1 }
        for n in 0..<1032 {
            if dict[n] == nil, dict[n-1] != nil, dict[n+1] != nil { return "\(n)" }
        }
        return "0"
    }
}

fileprivate func processInput(_ string: String) -> [String] {
    let lines = string.split(separator: "\n")
    return lines.map { String($0) }
}


fileprivate class BoardingPass {
    let row: Int
    let col: Int
    var id: Int { return row * 8 + col }
    
    init?(code: String) {
        guard code.count == 10 else { return nil }
        let split = code.index(code.startIndex, offsetBy: 7)
        let rowBinary = code[code.startIndex..<split].replacingOccurrences(of: "B", with: "1").replacingOccurrences(of: "F", with: "0")
        let colbinary = code[split..<code.endIndex].replacingOccurrences(of: "R", with: "1").replacingOccurrences(of: "L", with: "0")
        guard let r = Int(rowBinary, radix: 2) else { return nil }
        guard let c = Int(colbinary, radix: 2) else { return nil }
        row = r
        col = c
    }
}
