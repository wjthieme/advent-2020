//
//  16.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day16a: Solve = { input in
        let rules = getRules(input)
        let tickets = getNearbyTicket(input)
        var invalidNumbers: [Int] = []
        for ticket in tickets {
            for field in ticket {
                var isValid = false
                for rule in rules.values {
                    if rule.contains(field) {
                        isValid = true
                    }
                }
                if !isValid {
                    invalidNumbers.append(field)
                }
            }
        }
        let sum = invalidNumbers.reduce(0, +)
        return "\(sum)"
    }
    
    @objc static let day16b: Solve = { input in
        let rules = getRules(input)
        let tickets = getNearbyTicket(input)
        let myTicket = getYourTicket(input)
        var validTickets = Set(tickets)
        
        for ticket in tickets {
            for field in ticket {
                var isValid = false
                for rule in rules.values {
                    if rule.contains(field) {
                        isValid = true
                    }
                }
                if !isValid {
                    validTickets.remove(ticket)
                }
            }
        }
        
        var possibleRules: [Set<String>] = (0..<myTicket.count).map { _ in Set(rules.keys) }
        for ticket in validTickets {
            for (offset, field) in ticket.enumerated() {
                for (key, rule) in rules {
                    if !rule.contains(field) {
                        possibleRules[offset].remove(key)
                    }
                }
            }
        }
        let sorted = possibleRules.enumerated()
        let configurations = findFieldConfigurations(possibleRules)
        
        let indices = configurations.enumerated().filter({ $0.element.starts(with: "departure") }).map({ $0.offset })
        let values = indices.map({ myTicket[$0] })
        let mult = values.reduce(1, *)
        
        return "\(mult)"
    }
}

fileprivate let ruleRegex = try! NSRegularExpression(pattern: "^([a-z ]+): (\\d+)-(\\d+) or (\\d+)-(\\d+)$", options: [.anchorsMatchLines, .caseInsensitive])

fileprivate func getRules(_ string: String) -> [String: Set<Int>] {
    let range = NSRange(location: 0, length: string.count)
    let matches = ruleRegex.matches(in: string, options: [], range: range)
    var rules: [String: Set<Int>]  = [:]
    for match in matches {
        guard let key = Range(match.range(at: 1), in: string) else { continue }
        guard let min1 = Range(match.range(at: 2), in: string) else { continue }
        guard let max1 = Range(match.range(at: 3), in: string) else { continue }
        guard let min2 = Range(match.range(at: 4), in: string) else { continue }
        guard let max2 = Range(match.range(at: 5), in: string) else { continue }
        let range1 = Set((Int(string[min1]) ?? 0)...(Int(string[max1]) ?? 0))
        let range2 = Set((Int(string[min2]) ?? 0)...(Int(string[max2]) ?? 0))
        let ruleName = String(string[key])
        rules[ruleName] = range1.union(range2)
    }
    
    return rules
}

fileprivate func getYourTicket(_ string: String) -> [Int] {
    let blocks = string.components(separatedBy: "\n\n")
    guard blocks.count > 1 else { return [] }
    guard let line = blocks[1].components(separatedBy: "\n").last else { return [] }
    return line.split(separator: ",").compactMap { Int($0) }
}

fileprivate func getNearbyTicket(_ string: String) -> [[Int]] {
    let blocks = string.components(separatedBy: "\n\n")
    guard blocks.count > 2 else { return [] }
    let lines = blocks[2].components(separatedBy: "\n").dropFirst()
    return lines.map( { $0.split(separator: ",").compactMap( { Int($0) } ) } )
}

fileprivate func findFieldConfigurations(_ possibleFields: [Set<String>], _ n: Int = 0) -> [String] {
    var new = possibleFields
    while new.contains(where: { $0.count != 1 }) {
        for n in 0..<new.count {
            for i in 0..<new.count {
                if new[i].count == 1 && n != i {
                    new[n].remove(new[i].first!)
                }
            }
        }
    }
    
    return new.compactMap { $0.first }
}
