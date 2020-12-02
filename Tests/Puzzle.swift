//
//  Puzzle.swift
//  Tests
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation
import Advent

extension Puzzle {
    
    var testInput: String {
        switch self {
        case .day1a: return day1aInput
        case .day1b: return day1bInput
        case .day2a: return day2aInput
        case .day2b: return day2bInput
        }
    }
    
    
    var expectedTestOutput: String {
        switch self {
        case .day1a: return day1aOutput
        case .day1b: return day1bOutput
        case .day2a: return day2aOutput
        case .day2b: return day2bOutput
        }
    }
}
