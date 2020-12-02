//
//  Tests.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import XCTest
import Advent

class Test: XCTestCase {

    func testPuzzleSolvers() {
        for puzzle in Puzzle.allCases {
            let testOutput = puzzle.solve(puzzle.testInput)
            XCTAssertEqual(testOutput, puzzle.expectedTestOutput, "\(puzzle.rawValue) produced unexpected output.")
        }
    }
}
