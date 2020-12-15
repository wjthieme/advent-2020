//
//  13.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day13a: Solve = { input in
        guard let (timestamp, busses) = processInput(input) else { return "0" }
        for n in 0..<1000 {
            for bus in busses {
                if bus == -1 { continue }
                if (timestamp + n) % bus == 0 {
                    return "\(n * bus)"
                }
            }
        }
        return "0"
    }
    
    @objc static let day13b: Solve = { input in
        guard let (_, busses) = processInput(input) else { return "0" }
        var counter = 0
        var factor = 1
        
        for (offset, value) in busses.enumerated() {
            if value == -1 { continue }
            while (counter + offset) % value != 0 {
                counter += factor
            }
            factor *= value
        }
        return "\(counter)"
    }
}

fileprivate func processInput(_ string: String) -> (Int, [Int])? {
    let lines = string.components(separatedBy: "\n")
    guard let int = Int(lines[0]) else { return nil }
    let ids = lines[1].components(separatedBy: ",").compactMap { Int($0.replacingOccurrences(of: "x", with: "-1")) }
    return (int, ids)
}


