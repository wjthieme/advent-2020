//
//  14.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day14a: Solve = { input in
        let instructions = processInput(input)
        var memory: [String: Int] = [:]
        
        var mask: String = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        for instruction in instructions {
            if let newMask = instruction.mask {
                mask = newMask
            } else if let (address, value) = instruction.store {
                var newValue = ""
                for n in 0..<36 {
                    let mI = mask.index(mask.startIndex, offsetBy: n)
                    
                    if mask[mI] != "X" {
                        newValue.append(mask[mI])
                    } else {
                        let vI = value.index(value.startIndex, offsetBy: n)
                        newValue.append(value[vI])
                    }
                }
                memory[address] = Int(newValue, radix: 2)
            }
        }
        let sum = memory.values.reduce(0, +)
        return "\(sum)"
    }
    
    @objc static let day14b: Solve = { input in
        let instructions = processInput(input)
        var memory: [String: Int] = [:]
        
        var mask: String = "000000000000000000000000000000000000"
        for instruction in instructions {
            if let newMask = instruction.mask {
                mask = newMask
            } else if let (address, value) = instruction.store {
                var newAddress = ""
                for n in 0..<36 {
                    let mI = mask.index(mask.startIndex, offsetBy: n)
                    if mask[mI] != "0" {
                        newAddress.append(mask[mI])
                    } else {
                        let aI = address.index(address.startIndex, offsetBy: n)
                        newAddress.append(address[aI])
                    }
                }
                let permutations = permute(newAddress)
                permutations.forEach { memory[$0] = Int(value, radix: 2) }
            }
        }
        let sum = memory.values.reduce(0, +)
        return "\(sum)"
    }
}

fileprivate func processInput(_ string: String) -> [Instruction] {
    let lines = string.components(separatedBy: "\n")
    return lines.compactMap { Instruction($0) }
}

fileprivate let regex = try! NSRegularExpression(pattern: "^mem\\[(\\d+)\\] = (\\d+)$", options: [.caseInsensitive])

fileprivate class Instruction {
    let mask: String?
    let store: (String, String)?
    
    init?(_ string: String) {
        if string.starts(with: "mask") {
            mask = string.components(separatedBy: " = ")[1]
            store = nil
        } else {
            let range = NSRange(location: 0, length: string.count)
            guard let match = regex.firstMatch(in: string, options: [], range: range) else { return nil }
            guard let addressRange = Range(match.range(at: 1), in: string) else { return nil }
            guard let valueRange = Range(match.range(at: 2), in: string) else { return nil }
            let address = Int(string[addressRange]) ?? 0
            let addressString = String(address, radix: 2).paddingLeft(toLength: 36, with: "0")
            let value = Int(string[valueRange]) ?? 0
            let valueString = String(value, radix: 2).paddingLeft(toLength: 36, with: "0")
            store = (addressString, valueString)
            mask = nil
        }
    }
    
}

fileprivate func permute(_ string: String) -> [String] {
    guard let index = string.firstIndex(of: "X") else { return [string] }
    let zeroPermutations = permute(string.replacingCharacters(in: index...index, with: "0"))
    let onePermutations = permute(string.replacingCharacters(in: index...index, with: "1"))
    return zeroPermutations + onePermutations
}

fileprivate extension String {
    func paddingLeft(toLength: Int, with char: String) -> String {
        let toPad = toLength - count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: char, startingAt: 0) + self
    }
}
