//
//  07.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day7a: Solve = { input in
        let rules = Rules(input)
        let options = mayContain(rules, bag: "shiny gold")
        return "\(options.count)"
    }
    
    @objc static let day7b: Solve = { input in
        let rules = Rules(input)
        let options = bagsInside(rules, bag: "shiny gold")
        return "\(options)"
    }
}

fileprivate func mayContain(_ rules: Rules, bag: String) -> Set<String> {
    let direct = Set(rules.filter { $0.value[bag] != nil }.keys)
    let indirect = direct.map { mayContain(rules, bag: $0) }
    return indirect.reduce(into: direct) {  $0 = $0.union($1) }
}

fileprivate func bagsInside(_ rules: Rules, bag: String) -> Int {
    guard let rule = rules[bag] else { return 0 }
    let direct = rule.map({ $0.value }).reduce(0, +)
    let indirect = rule.map { bagsInside(rules, bag: $0.key) * $0.value }
    return indirect.reduce(direct, +)
}

fileprivate typealias Rules = [String: Subrules]
fileprivate typealias Subrules = [String: Int]

fileprivate extension Rules {
    static let regex = try! NSRegularExpression(pattern: "^(\\w+ \\w+) bags contain (.+).$", options: [.caseInsensitive, .anchorsMatchLines])
    
    init(_ string: String) {
        let range = NSRange(location: 0, length: string.count)
        let matches = Rules.regex.matches(in: string, options: [], range: range)
        
        self = [:]
        for match in matches {
            guard let colorRange = Range(match.range(at: 1), in: string) else { continue }
            let color = String(string[colorRange])
            guard let subrulesRange = Range(match.range(at: 2), in: string) else { continue }
            let subrules = Subrules(String(string[subrulesRange]).replacingOccurrences(of: ", ", with: "\n"))
            self[color] = subrules
        }
    }
}

fileprivate extension Subrules {
    static let regex = try! NSRegularExpression(pattern: "^(\\d+) (\\w+ \\w+) bags?$", options: [.caseInsensitive, .anchorsMatchLines])
    
    init(_ string: String) {
        let range = NSRange(location: 0, length: string.count)
        let matches = Subrules.regex.matches(in: string, options: [], range: range)
        
        self = [:]
        for match in matches {
            guard let quantityRange = Range(match.range(at: 1), in: string) else { continue }
            let quantity = Int(string[quantityRange]) ?? 0
            guard let colorRange = Range(match.range(at: 2), in: string) else { continue }
            let color = String(string[colorRange])
            self[color] = quantity
        }
    }
    
}
