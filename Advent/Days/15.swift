//
//  15.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day15a: Solve = { input in
        var numbers = processInput(input)
        while numbers.count < 2020 {
            guard let last = numbers.last else { continue }
            if let index = numbers.dropLast().lastIndex(of: last) {
                numbers.append(numbers.count - index - 1)
            } else {
                numbers.append(0)
            }
        }
        let last = numbers.last ?? 0
        return "\(last)"
    }
    
    @objc static let day15b: Solve = { input in
        var numbers = processInput(input)
        let sequence = numbers.enumerated().dropLast().map { ($0.element, $0.offset) }
        var dict = Dictionary(uniqueKeysWithValues: sequence)
        var nextAdd = numbers.enumerated().map({ ($0.element, $0.offset) }).last
        while numbers.count < 30000000 {
            let last = numbers.last ?? 0
            let next = nextAdd
            if let index = dict[last] {
                let i = numbers.count - index - 1
                nextAdd = (i, numbers.count)
                numbers.append(i)
            } else {
                nextAdd = (0, numbers.count)
                numbers.append(0)
            }
            if let next = next {
                dict[next.0] = next.1
            }
        }
        return "\(numbers.last ?? 0)"
    }
}

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: ",")
    return lines.compactMap({ Int($0) })
}
