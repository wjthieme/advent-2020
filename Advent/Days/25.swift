//
//  25.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day25a: Solve = { input in
        var (publicDoor, publicCard) = processInput(input)
        let loopDoor = reverseEngineer(publicDoor)
        let key = calculateKey(publicCard, loop: loopDoor)
        return "\(key)"
    }
    
    @objc static let day25b: Solve = { input in

        return "0"
    }
}



fileprivate func processInput(_ string: String) -> (Int, Int) {
    let lines = string.components(separatedBy: "\n")
    guard lines.count > 1 else { return (0, 0)}
    guard let first = Int(lines[0]) else { return (0, 0) }
    guard let second = Int(lines[1]) else { return (0, 0) }
    return (first, second)
}


fileprivate func reverseEngineer(_ publicKey: Int, subject: Int = 7, mod: Int = 20201227) -> Int {
    var counter = 0
    var a = 1
    while a != publicKey {
        a = (a * subject) % mod
        counter += 1
    }
    return counter
}

fileprivate func calculateKey(_ subject: Int, loop: Int, mod: Int = 20201227) -> Int {
    var a = 1
    for _ in 0..<loop {
        a = (a * subject) % mod
    }
    return a
}
