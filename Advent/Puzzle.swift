//
//  Puzzle.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation

public typealias Solve = @convention(block) (String) -> String

public enum Puzzle: String, CaseIterable {
    case day1a, day1b
    case day2a, day2b
    case day3a, day3b
    case day4a, day4b
    case day5a, day5b
    case day6a, day6b
    case day7a, day7b
    case day8a, day8b
    case day9a, day9b
    case day10a, day10b
    case day11a, day11b
    case day12a, day12b
    case day13a, day13b
    case day14a, day14b
    case day15a, day15b
    case day16a, day16b
    case day17a, day17b
    case day18a, day18b
    case day19a, day19b
    case day20a, day20b
    case day21a, day21b
    case day22a, day22b
    case day23a, day23b
    case day24a, day24b
    case day25a, day25b
    
    
    public func solve(_ input: String) -> String {
        let block = Solvers.value(forKey: rawValue) as AnyObject
        let solver = unsafeBitCast(block, to: Solve.self)
        return solver(input)
    }
    
}

class Solvers: NSObject { override static func value(forUndefinedKey key: String) -> Any? { return { _ in "0" } as Solve } }
