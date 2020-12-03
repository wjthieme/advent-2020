//
//  03.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day3a: Solve = { input in
        let values = processInput(input)
        let count = slopeRun(values, xFactor: 3, yFactor: 1)
        return "\(count)"
    }
    
    @objc static let day3b: Solve = { input in
        let values = processInput(input)
        let factors: [(Double, Double)] = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        let counts = factors.map { slopeRun(values, xFactor: $0, yFactor: $1) }
        let multiplied = counts.reduce(1, *)
        return "\(multiplied)"
    }
}

fileprivate func processInput(_ string: String) -> [[Character]] {
    let lines = string.split(separator: "\n")
    return lines.map { $0.map { $0 } }
}

fileprivate func slopeRun(_ slope: [[Character]], xFactor: Double, yFactor: Double) -> Int {
    var counter = 0
    for y in stride(from: 0, to: slope.count, by: Int(yFactor)) {
        let x = Int(Double(y)*xFactor/yFactor) % slope[y].count
        if slope[y][x] == "#" { counter += 1 }
    }
    return counter
}
