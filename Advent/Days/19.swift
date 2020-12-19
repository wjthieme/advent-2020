//
//  19.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day19a: Solve = { input in
        let rules = getRules(input)
        let rule = expandRule(rules, "0").joined()
        guard let regex = try? NSRegularExpression(pattern: "^\(rule)$", options: [.anchorsMatchLines, .caseInsensitive]) else { return "0" }
        let messages = getMessages(input)
        let range = NSRange(location: 0, length: messages.count)
        let count = regex.numberOfMatches(in: messages, options: [], range: range)
        return "\(count)"
    }
    
    @objc static let day19b: Solve = { input in
        var rules = getRules(input)
        rules["8"] = ["42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", "|", "42", "(", "42", ")", ")", ")", ")", ")", ")", ")", ")", ")", ")" ]
        rules["11"] = ["42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "(", "42", "31", "|", "42", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31", ")", "31"]
        let rule = expandRule(rules, "0").joined()
        guard let regex = try? NSRegularExpression(pattern: "^\(rule)$", options: [.anchorsMatchLines, .caseInsensitive]) else { return "0" }
        let messages = getMessages(input)
        let range = NSRange(location: 0, length: messages.count)
        let count = regex.numberOfMatches(in: messages, options: [], range: range)
        return "\(count)"
    }
}

fileprivate func getRules(_ string: String) -> [String: [String]] {
    let blocks = string.components(separatedBy: "\n\n")
    guard blocks.count > 0 else { return [:] }
    let lines = blocks[0].components(separatedBy: "\n")
    let rules = lines.map({ $0.components(separatedBy: ": ") }).filter({ $0.count > 1 })
    let pairs = rules.map({ ($0[0], $0[1].replacingOccurrences(of: "\"", with: "").components(separatedBy: " ")) })
    return pairs.reduce(into: [String: [String]]()) { $0[$1.0] = $1.1 }
}

fileprivate func getMessages(_ string: String) -> String {
    let blocks = string.components(separatedBy: "\n\n")
    guard blocks.count > 1 else { return "" }
    return blocks[1]
}

fileprivate func expandRule(_ rules: [String: [String]], _ ind: String) -> [String] {
    guard var rule = rules[ind] else { return [] }
    if rule.count == 1 { return rule }
    while let n = rule.firstIndex(where: { Int($0) != nil }) {
        let replace = expandRule(rules, rule[n])
        rule.remove(at: n)
        rule.insert(contentsOf: replace, at: n)
    }
    return ["("] + rule + [")"]
}
