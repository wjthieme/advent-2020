//
//  10.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day10a: Solve = { input in
        let values = processInput(input)
        let groups = createGroups(values)
        let diff3 = groups.count
        let diff1 = groups.reduce(0, { $0 + $1.count - 1 })
        return "\(diff1 * diff3)"
    }
    
    @objc static let day10b: Solve = { input in
        let values = processInput(input)
        let groups = createGroups(values)
        let paths = calculatePaths(groups)
        return "\(paths)"
    }
}

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: "\n")
    return [0] + lines.compactMap { Int($0) }
}

fileprivate func createGroups(_ input: [Int]) -> [[Int]] {
    var groups: [[Int]] = []
    var group: [Int] = []
    var previous = -1
    for value in input.sorted() {
        if value != previous + 1 {
            groups.append(group)
            group = []
        }
        group.append(value)
        previous = value
    }
    groups += [group]
    return groups
}

fileprivate func calculatePaths(_ groups: [[Int]]) -> Int {
    var paths = 1
    for group in groups {
        switch group.count {
        case 3: paths *= 2
        case 4: paths *= 4
        case 5: paths *= 7
        default: break
        }
    }
    return paths
}
