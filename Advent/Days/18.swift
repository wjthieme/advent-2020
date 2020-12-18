//
//  18.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day18a: Solve = { input in
        let values = processInput(input)
        let calc = values.map({ calculateArithmic(samePrecedence: $0) })
        let results = calc.compactMap({ Int($0) })
        let sum = results.reduce(0, +)
        return "\(sum)"
    }
    
    @objc static let day18b: Solve = { input in
        let values = processInput(input)
        let calc = values.map({ calculateArithmic(orderedPrecedence: $0) })
        let results = calc.compactMap({ Int($0) })
        let sum = results.reduce(0, +)
        return "\(sum)"
    }
}

fileprivate func processInput(_ string: String) -> [String] {
    let lines = string.components(separatedBy: "\n")
    return lines
}

fileprivate let regex = try! NSRegularExpression(pattern: "^(\\d+) ([+*/-]) (\\d+)", options: [.caseInsensitive])
fileprivate let addRegex = try! NSRegularExpression(pattern: "(\\d+) ([+-]) (\\d+)", options: [.caseInsensitive])
fileprivate let multRegex = try! NSRegularExpression(pattern: "(\\d+) ([*/]) (\\d+)", options: [.caseInsensitive])

fileprivate func calculateArithmic(samePrecedence string: String) -> String {
    var calc = string
    while let parenthisis = firstParenthesis(calc) {
        let start = calc.index(after: parenthisis.lowerBound)
        let end = calc.index(before: parenthisis.upperBound)
        let sub = calculateArithmic(samePrecedence: String(calc[start...end]))
        calc.replaceSubrange(parenthisis, with: sub)
    }
    
    while let match = regex.firstMatch(in: calc, options: [], range: NSRange(location: 0, length: calc.count)) {
        guard let range = Range(match.range(at: 0), in: calc) else { continue }
        guard let lhsRange = Range(match.range(at: 1), in: calc) else { continue }
        guard let opRange = Range(match.range(at: 2), in: calc) else { continue }
        guard let rhsRange = Range(match.range(at: 3), in: calc) else { continue }
        guard let lhs = Int(calc[lhsRange]) else { continue }
        guard let rhs = Int(calc[rhsRange]) else { continue }
        var value: String
        switch calc[opRange] {
        case "*": value = "\(lhs * rhs)"
        case "+": value = "\(lhs + rhs)"
        case "-": value = "\(lhs - rhs)"
        case "/": value = "\(lhs / rhs)"
        default: continue
        }
        calc.replaceSubrange(range, with: value)
    }
    
    return calc
}

fileprivate func calculateArithmic(orderedPrecedence string: String) -> String {
    var calc = string
    while let parenthisis = firstParenthesis(calc) {
        let start = calc.index(after: parenthisis.lowerBound)
        let end = calc.index(before: parenthisis.upperBound)
        let sub = calculateArithmic(orderedPrecedence: String(calc[start...end]))
        calc.replaceSubrange(parenthisis, with: sub)
    }
    
    while let match = addRegex.firstMatch(in: calc, options: [], range: NSRange(location: 0, length: calc.count)) {
        guard let range = Range(match.range(at: 0), in: calc) else { continue }
        guard let lhsRange = Range(match.range(at: 1), in: calc) else { continue }
        guard let opRange = Range(match.range(at: 2), in: calc) else { continue }
        guard let rhsRange = Range(match.range(at: 3), in: calc) else { continue }
        guard let lhs = Int(calc[lhsRange]) else { continue }
        guard let rhs = Int(calc[rhsRange]) else { continue }
        var value: String
        switch calc[opRange] {
        case "*": value = "\(lhs * rhs)"
        case "+": value = "\(lhs + rhs)"
        case "-": value = "\(lhs - rhs)"
        case "/": value = "\(lhs / rhs)"
        default: continue
        }
        calc.replaceSubrange(range, with: value)
    }
    
    while let match = multRegex.firstMatch(in: calc, options: [], range: NSRange(location: 0, length: calc.count)) {
        guard let range = Range(match.range(at: 0), in: calc) else { continue }
        guard let lhsRange = Range(match.range(at: 1), in: calc) else { continue }
        guard let opRange = Range(match.range(at: 2), in: calc) else { continue }
        guard let rhsRange = Range(match.range(at: 3), in: calc) else { continue }
        guard let lhs = Int(calc[lhsRange]) else { continue }
        guard let rhs = Int(calc[rhsRange]) else { continue }
        var value: String
        switch calc[opRange] {
        case "*": value = "\(lhs * rhs)"
        case "+": value = "\(lhs + rhs)"
        case "-": value = "\(lhs - rhs)"
        case "/": value = "\(lhs / rhs)"
        default: continue
        }
        calc.replaceSubrange(range, with: value)
    }
    
    return calc
}

fileprivate func firstParenthesis(_ string: String) -> ClosedRange<String.Index>? {
    var start: String.Index?
    for n in 0..<string.count {
        let index = string.index(string.startIndex, offsetBy: n)
        if string[index] == "(" { start = index }
        guard let start = start else { continue }
        if string[index] == ")" { return start...index }
    }
    return nil
}
