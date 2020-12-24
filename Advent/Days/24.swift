//
//  24.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day24a: Solve = { input in
        let values = processInput(input)
        var result: Set<Tile> = []
        values.forEach({ result.toggle($0) })
        return "\(result.count)"
    }
    
    @objc static let day24b: Solve = { input in
        let values = processInput(input)
        var result: Set<Tile> = []
        values.forEach({ result.toggle($0) })
        guard let minX = values.min(by: { $0.x < $1.x })?.x else { return "0" }
        guard let maxX = values.max(by: { $0.x < $1.x })?.x else { return "0" }
        guard let minY = values.min(by: { $0.y < $1.y })?.y else { return "0" }
        guard let maxY = values.max(by: { $0.y < $1.y })?.y else { return "0" }
        var xRange = minX-1...maxX+1
        var yRange = minY-1...maxY+1
        
        for _ in 0..<100 {
            result = convolve(result, xRange: xRange, yRange: yRange)
            xRange = xRange.expanded(by: 1)
            yRange = yRange.expanded(by: 1)
        }
        
        return "\(result.count)"
    }
}

fileprivate func processInput(_ string: String) -> [Tile] {
    let lines = string.components(separatedBy: "\n")
    return lines.map({ Tile($0) })
}

fileprivate class Tile: Hashable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    let x: Int
    let y: Int
    
    convenience init(_ string: String) {
        var remaining = string
        var x = 0
        var y = 0
        
        while !remaining.isEmpty {
            var getSecond = false
            let first = remaining.removeFirst()
            switch first {
            case "n": y += 1; getSecond = true
            case "e": x += 2
            case "w": x -= 2
            case "s": y -= 1; getSecond = true
            default: break
            }
            
            if getSecond {
                let second = remaining.removeFirst()
                switch second {
                case "e": x += 1
                case "w": x -= 1
                default: break
                }
            }
        }
        
        self.init(x: x, y: y)
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

fileprivate extension Set {
    mutating func toggle(_ member: Element) {
        if contains(member) {
            remove(member)
        } else {
            insert(member)
        }
    }
}

fileprivate extension ClosedRange where Bound == Int {
    
    func expanded(by value: Bound) -> ClosedRange {
        let lower = lowerBound - value
        let upper = upperBound + value
        return lower...upper
    }
}

fileprivate let kernel = [ (-1, -1), (-2, 0), (-1, 1), (1, -1), (2, 0), (1, 1) ]

fileprivate func convolve(_ input: Set<Tile>, xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) -> Set<Tile> {
    var result = input
    for x in xRange {
        for y in yRange {
            if abs(y % 2) != abs(x % 2) { continue }
            let own = Tile(x: x, y: y)
            let adjecent = kernel.map({ ($0.0 + x, $0.1 + y) })
            let contains = adjecent.map({ input.contains(Tile(x: $0.0, y: $0.1))  })
            let count = contains.filter({ $0 }).count
            if input.contains(own) && (count == 0 || count > 2) {
                result.remove(own)
            } else if !input.contains(own) && count == 2 {
                result.insert(own)
            }
        }
    }
    return result
}
