//
//  Puzzl.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation

typealias Solve = ((String) -> String)

enum Puzzle: String, CaseIterable {
    case day1a, day1b
    
    
    func solve(_ input: String) -> String {
        switch self {
        case .day1a: return solveDay1A(input)
        case .day1b: return solveDay1B(input)
        }
    }
    
}
