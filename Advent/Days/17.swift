//
//  17.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day17a: Solve = { input in
        let values = processInput(input)
        let dim = Int(sqrt(Double(values.count)))
        var grid = Grid(values, [1, dim, dim]).pad()
        for n in 0..<6 {
            grid = grid.pad()
            grid = grid.convolve()
        }
        return "\(grid.activeCount)"
    }
    
    @objc static let day17b: Solve = { input in
        let values = processInput(input)
        let dim = Int(sqrt(Double(values.count)))
        var grid = Grid(values, [1, 1, dim, dim]).pad()
        for n in 0..<6 {
            grid = grid.pad()
            grid = grid.convolve()
        }
        return "\(grid.activeCount)"
    }
}

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: "\n")
    return lines.flatMap( { $0.map({ $0 == "#" ? 1 : 0 }) })
}

fileprivate class Grid {
    private let values: [Int]
    let shape: [Int]
    private lazy var kernel: [Int] =  { configurations(Array(-1...1), shape.count).filter({ $0 != Array(repeating: 0, count: shape.count) }).map({ ind(from: $0, shape: shape) }) }()

    init(_ values: [Int], _ shape: [Int]) {
        self.values = values
        self.shape = shape
    }
    
    func pad(by pad: Int = 1) -> Grid {
        let newShape = Array(shape).map { $0 + pad * 2 }
        var new = [Int](repeating: 0, count: newShape.reduce(1, *))
    
        for n in 0..<values.count {
            let i = ind(from: sub(from: n, shape: shape).map({ $0 + pad }), shape: newShape)
            new[i] = values[n]
        }
        return Grid(new, newShape)
    }
    
    func convolve() -> Grid {
        var new = [Int](repeating: 0, count: values.count)
        for n in 0..<values.count {
            let ind = kernel.map { $0 + n }
            let sum = ind.compactMap({ values[safe: $0] }).reduce(0, +)
            if values[n] == 1 && !(2...3).contains(sum) {
                new[n] = 0
            } else if values[n] == 0 && sum == 3 {
                new[n] = 1
            } else {
                new[n] = values[n]
            }
        }
        return Grid(new, shape)
    }
    
    var activeCount: Int { return values.filter({ $0 == 1 }).count }
}

fileprivate extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

fileprivate func configurations(_ options: [Int], _ maxCount: Int, _ partial: [Int] = []) -> [[Int]] {
    if partial.count == maxCount { return [partial] }
    return options.flatMap({ configurations(options, maxCount, partial + [$0]) })
}

fileprivate func ind(from sub: [Int], shape: [Int]) -> Int {
    return sub.enumerated().map({ $0.element * shape[0..<$0.offset].reduce(1, *) }).reduce(0, +)
}

fileprivate func sub(from ind: Int, shape: [Int]) -> [Int] {
    return shape.enumerated().map({ (ind / (shape[0..<$0.offset].reduce(1, *))) % $0.element })
}

