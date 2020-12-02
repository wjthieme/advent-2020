//
//  01.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day1a: Solve = { input in
        let values = processInput(input)
        let result = sumEquals2020Multiplied(values, iterations: 2)
        return "\(result)"
    }
    
    @objc static let day1b: Solve = { input in
        let values = processInput(input)
        let result = sumEquals2020Multiplied(values, iterations: 3)
        return "\(result)"
    }
}

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.split(separator: "\n")
    return lines.compactMap { Int($0) }
}

fileprivate func sumEquals2020Multiplied(_ input: [Int], iterations: Int) -> Int {
    let count = Int(pow(Float(input.count), Float(iterations)))
    var indexes = (0..<iterations).map { _ in 0 }
    for _ in 0..<count {
        let values = indexes.map { input[$0] }
        let sum = values.reduce(0, +)
        if sum == 2020 {
            return values.reduce(1, *)
        }
        
        indexes[0] += 1
        while let i = indexes.firstIndex(of: input.count) {
            indexes[i] = 0
            indexes[i + 1] += 1
        }
    }
    return 0
}
