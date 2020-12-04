//
//  04.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day4a: Solve = { input in
        let values = processInput(input)
        let valid = values.filter { PassportFields.validA(string: $0) }
        return "\(valid.count)"
    }
    
    @objc static let day4b: Solve = { input in
        let values = processInput(input)
        let valid = values.filter { PassportFields.validB(string: $0) }
        return "\(valid.count)"
    }
}

fileprivate func processInput(_ string: String) -> [String] {
    let lines = string.components(separatedBy: "\n\n")
    return lines
}

fileprivate enum PassportFields: String, CaseIterable {
    case birthYear = "byr"
    case issueYear = "iyr"
    case expirationYear = "eyr"
    case height = "hgt"
    case hairColor = "hcl"
    case eyeColor = "ecl"
    case passId = "pid"
    case countryId = "cid"
    
    static func validA(string: String) -> Bool {
        for field in PassportFields.allCases {
            if !field.validA(string: string) {
                return false
            }
        }
        return true
    }
    
    static func validB(string: String) -> Bool {
        for field in PassportFields.allCases {
            if !field.validB(string: string) {
                return false
            }
        }
        return true
    }
    
    private func validA(string: String) -> Bool {
        if self == .countryId { return true }
        return string.contains(rawValue)
    }
    
    private func validB(string: String) -> Bool {
        if self == .countryId { return true }
        if !string.contains(rawValue) { return false }
        
        let range = NSRange(location: 0, length: string.count)
        switch self {
        case .birthYear, .issueYear, .expirationYear:
            guard let regex = try? NSRegularExpression(pattern: "\(rawValue):([0-9]{4})(?: |\n|$)", options: [.caseInsensitive]) else { return false }
            guard let match = regex.firstMatch(in: string, options: [], range: range) else { return false }
            guard let range = Range(match.range(at: 1), in: string) else { return false }
            let year = Int(string[range]) ?? 0
            
            if self == .birthYear, year >= 1920 && year <= 2002 { return true }
            if self == .issueYear, year >= 2010 && year <= 2020 { return true }
            if self == .expirationYear, year >= 2020 && year <= 2030 { return true }
            return false
        case .height:
            guard let regex = try? NSRegularExpression(pattern: "\(rawValue):([0-9]+)(cm|in)(?: |\n|$)", options: [.caseInsensitive]) else { return false }
            guard let match = regex.firstMatch(in: string, options: [], range: range) else { return false }
            guard let heightRange = Range(match.range(at: 1), in: string) else { return false }
            guard let unitRange = Range(match.range(at: 2), in: string) else { return false }
            let height = Int(string[heightRange]) ?? 0
            if string[unitRange] == "cm", height >= 150 && height <= 193 { return true }
            if string[unitRange] == "in", height >= 59 && height <= 76 { return true }
            return false
        case .hairColor:
            guard let regex = try? NSRegularExpression(pattern: "\(rawValue):#[0-9a-f]{6}(?: |\n|$)", options: [.caseInsensitive]) else { return false }
            return regex.firstMatch(in: string, options: [], range: range) != nil
        case .eyeColor:
            guard let regex = try? NSRegularExpression(pattern: "\(rawValue):amb|blu|brn|gry|grn|hzl|oth(?: |\n|$)", options: [.caseInsensitive]) else { return false }
            return regex.firstMatch(in: string, options: [], range: range) != nil
        case .passId:
            guard let regex = try? NSRegularExpression(pattern: "\(rawValue):[0-9]{9}(?: |\n|$)", options: [.caseInsensitive]) else { return false }
            return regex.firstMatch(in: string, options: [], range: range) != nil
        default: return true
        }
    }
}
