//
//  Puzzle.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation
import Advent

extension Puzzle {
    var testInput: String { return Inputs.value(forKey: rawValue) as? String ?? "" }
    var expectedTestOutput: String { return Outputs.value(forKey: rawValue) as? String ?? "0" }
}

class Inputs: NSObject { override static func value(forUndefinedKey key: String) -> Any? { return nil } }
class Outputs: NSObject { override static func value(forUndefinedKey key: String) -> Any? { return nil } }
