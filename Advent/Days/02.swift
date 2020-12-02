//
//  02.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day2a: Solve = { input in
        let values = processInput(input)
        let valid = values.filter { $0.isValidA }
        return "\(valid.count)"
    }
    
    @objc static let day2b: Solve = { input in
        let values = processInput(input)
        let valid = values.filter { $0.isValidB }
        return "\(valid.count)"
    }
}

fileprivate let regex = try! NSRegularExpression(pattern: "^([0-9]{1,2})-([0-9]{1,2}) ([a-z]{1}): ([a-z]*)$", options: [.anchorsMatchLines, .caseInsensitive])

fileprivate func processInput(_ string: String) -> [Value] {
    let range = NSRange(location: 0, length: string.count)
    let matches = regex.matches(in: string, options: [], range: range)
    return matches.compactMap { Value(match: $0, original: string) }
}

fileprivate class Value {
    let letter: Character
    let min: Int
    let max: Int
    let pass: String
    
    var range: ClosedRange<Int> { return min...max }
    
    init?(match: NSTextCheckingResult, original: String) {
        guard let minRange = Range(match.range(at: 1), in: original) else { return nil }
        guard let maxRange = Range(match.range(at: 2), in: original) else { return nil }
        min = Int(original[minRange]) ?? 0
        max = Int(original[maxRange]) ?? 0

        guard let letterRange = Range(match.range(at: 3), in: original) else { return nil }
        letter = Character(String(original[letterRange]))
        
        guard let passRange = Range(match.range(at: 4), in: original) else { return nil }
        pass = String(original[passRange])
    }
    
    var isValidA: Bool {
        let filtered = pass.filter { $0 == letter }
        return range.contains(filtered.count)
    }
    
    var isValidB: Bool {
        let firstIndex = pass.index(pass.startIndex, offsetBy: min-1)
        let secondIndex = pass.index(pass.startIndex, offsetBy: max-1)
        return (pass[firstIndex] == letter) ^^ (pass[secondIndex] == letter)
    }
}

infix operator ^^: LogicalConjunctionPrecedence
extension Bool {
    static func ^^(lhs:Bool, rhs:Bool) -> Bool {
        return (lhs && !rhs) || (!lhs && rhs)
    }
}
