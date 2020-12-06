//
//  06.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day6a: Solve = { input in
        let values = processInput(input).map { $0.flatMap { $0 } }
        let uniques = values.map { Set($0) }
        let counts = uniques.map { $0.count }
        let sum = counts.reduce(0, +)
        return "\(sum)"
    }
    
    @objc static let day6b: Solve = { input in
        let values = processInput(input)
        let intersections = values.map  { $0.reduce(into: Set($0.first ?? []), { $0 = $0.intersection($1) }) }
        let counts = intersections.map { $0.count }
        let sum = counts.reduce(0, +)
        return "\(sum)"
    }
}

fileprivate func processInput(_ string: String) -> [[Set<Character>]] {
    let lines = string.components(separatedBy: "\n\n")
    return lines.map { $0.components(separatedBy: "\n").map { Set($0) } }
}
