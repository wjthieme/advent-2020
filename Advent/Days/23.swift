//
//  23.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day23a: Solve = { input in
        var cups = input.compactMap({ Int(String($0)) })
        let result = playCups(cups, 100)
        let final = result.dropFirst().map({ String($0) }).joined()
        return "\(final)"
    }
    
    @objc static let day23b: Solve = { input in
        var cups = input.compactMap({ Int(String($0)) })
        cups = cups + (cups.count+1...1000000).map({ $0 })
        let result = playCups(cups, 10000000)
        let first = result[1]
        let second = result[2]
        let final = first * second
        return "\(final)"
    }
}

fileprivate func playCups(_ cups: [Int], _ iterations: Int) -> [Int] {
    var result = cups.makeIndexed()
    var current = cups[0]
    for _ in 1...iterations {
        let values = (0..<3).map { _ in result.remove(after: current) }
        var target = current - 1
        while values.contains(target) || target < 1 {
            target -= 1
            if target < 1 {
                target = cups.count
            }
        }
        values.reversed().forEach({ result.insert($0, after: target) })
        current = result[current]
    }
    return result.makeUnindexed()
}

extension Array where Element == Int {
    mutating func remove(after: Int) -> Int {
        let toRemove = self[after]
        self[after] = self[toRemove]
        return toRemove
    }
    
    mutating func insert(_ new: Int, after: Int) {
        let old = self[after]
        self[after] = new
        self[new] = old
    }
    
    func makeIndexed() -> [Int] {
        var indexed = Array(repeating: 0, count: count+2)
        enumerated().forEach({ indexed[$0.element] = self[($0.offset + 1) % count] })
        return indexed
    }
    
    func makeUnindexed() -> [Int] {
        var next = 1
        var unindexed: [Int] = [1]
        while self[next] != 1 {
            next = self[next]
            unindexed.append(next)
        }
        return unindexed
    }
}
