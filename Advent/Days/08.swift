//
//  08.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day8a: Solve = { input in
        let instructions = processInput(input)
        let output = runInstructions(instructions)
        return "\(output)"
    }
    
    @objc static let day8b: Solve = { input in
        let instructions = processInput(input)
        let jmps = instructions.enumerated().filter({ $0.element.starts(with: "jmp") }).map { $0.offset }
        let nops = instructions.enumerated().filter({ $0.element.starts(with: "nop") }).map { $0.offset }
        
        for jmp in jmps {
            var changedInstructions = instructions
            changedInstructions[jmp] = changedInstructions[jmp].replacingOccurrences(of: "jmp", with: "nop")
            if let value = runInstructions(toEnd: changedInstructions) { return "\(value)" }
        }
        
        for nop in nops {
            var changedInstructions = instructions
            changedInstructions[nop] = changedInstructions[nop].replacingOccurrences(of: "nop", with: "jmp")
            if let value = runInstructions(toEnd: changedInstructions) { return "\(value)" }
        }
        
        return "0"
    }
}



fileprivate func processInput(_ string: String) -> [String] {
    let lines = string.components(separatedBy: "\n")
    return lines
}

fileprivate func runInstructions(_ instructions: [String]) -> Int {
    var accumulator = 0
    var executed: [Int] = []
    nextInstruction(instructions, executed: &executed, accumulator: &accumulator)
    return accumulator
}

fileprivate func runInstructions(toEnd instructions: [String]) -> Int? {
    var accumulator = 0
    var executed: [Int] = []
    if nextInstruction(instructions, executed: &executed, accumulator: &accumulator) {
        return accumulator
    }
    return nil
}

@discardableResult fileprivate func nextInstruction(_ instructions: [String], executed: inout [Int], accumulator: inout Int) -> Bool {
    let index = executed.last ?? 0
    if index == instructions.count { return true }
    let instruction = instructions[index].split(separator: " ")
    let value = Int(instruction[1]) ?? 0
    
    let next = instruction.first == "jmp" ? index + value : index + 1
    if executed.contains(next) { return false }
    executed.append(next)
    accumulator = instruction.first == "acc" ? accumulator + value : accumulator
    return nextInstruction(instructions, executed: &executed, accumulator: &accumulator)
}
