//
//  Puzzle.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation

public typealias Solve = ((String) -> String)

public enum Puzzle: String, CaseIterable {
    case day1a, day1b
    case day2a, day2b
    
    
    public func solve(_ input: String) -> String {
        
        switch self {
        case .day1a: return day1aSolver(input)
        case .day1b: return day1bSolver(input)
        case .day2a: return day2aSolver(input)
        case .day2b: return day2bSolver(input)
        }
    }
    
}
