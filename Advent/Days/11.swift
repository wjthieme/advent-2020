//
//  11.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day11a: Solve = { input in
        var values = processInput(input)
        let floorplan = nextIteration(values, adjecentFunc: adjectentSeats)
        let count = floorplan.flatMap({ $0 }).filter({ $0 == "#" }).count
        return "\(count)"
    }
    
    @objc static let day11b: Solve = { input in
        var values = processInput(input)
        let floorplan = nextIteration(values, emptyRule: 5, adjecentFunc: fullAdjecentSeats)
        let count = floorplan.flatMap({ $0 }).filter({ $0 == "#" }).count
        return "\(count)"
    }
}

fileprivate func processInput(_ string: String) -> [[Character]] {
    let lines = string.components(separatedBy: "\n")
    return lines.map { $0.map { $0 } }
}

fileprivate func nextIteration(_ floorplan: [[Character]], emptyRule: Int = 4, adjecentFunc: ([[Character]], Int, Int) -> [Character]) -> [[Character]] {
    var newFloorplan = floorplan
    for y in 0..<floorplan.count {
        for x in 0..<floorplan[y].count {
            let adjacent = adjecentFunc(floorplan, x, y)
            switch floorplan[y][x] {
            case "#":
                if adjacent.filter({ $0 == "#" }).count >= emptyRule {
                    newFloorplan[y][x] = "L"
                }
            case "L":
                if adjacent.filter({ $0 == "#" }).count == 0 {
                    newFloorplan[y][x] = "#"
                }
            default: break
            }
        }
    }
    return newFloorplan == floorplan ? newFloorplan : nextIteration(newFloorplan, emptyRule: emptyRule, adjecentFunc: adjecentFunc)
}

fileprivate func adjectentSeats(_ floorplan: [[Character]], x: Int, y: Int) -> [Character] {
    var adjecent: [Character] = []
    adjecent.appendOrNil(floorplan[safe: y-1]?[safe: x-1])
    adjecent.appendOrNil(floorplan[safe: y-1]?[safe: x])
    adjecent.appendOrNil(floorplan[safe: y-1]?[safe: x+1])
    adjecent.appendOrNil(floorplan[safe: y]?[safe: x-1])
    adjecent.appendOrNil(floorplan[safe: y]?[safe: x+1])
    adjecent.appendOrNil(floorplan[safe: y+1]?[safe: x-1])
    adjecent.appendOrNil(floorplan[safe: y+1]?[safe: x])
    adjecent.appendOrNil(floorplan[safe: y+1]?[safe: x+1])
    return adjecent
}

fileprivate func fullAdjecentSeats(_ floorplan: [[Character]], x: Int, y: Int) -> [Character] {
    var adjecent: [Character] = []
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: -1, yFactor: -1))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: -1, yFactor: 0))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: -1, yFactor: 1))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: 0, yFactor: -1))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: 0, yFactor: 1))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: 1, yFactor: -1))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: 1, yFactor: 0))
    adjecent.appendOrNil(fullAdjecentSeat(floorplan, x: x, y: y, xFactor: 1, yFactor: 1))
    return adjecent
}

fileprivate func fullAdjecentSeat(_ floorplan: [[Character]], x: Int, y: Int, xFactor: Int, yFactor: Int) -> Character? {
    var xFind = x + xFactor
    var yFind = y + yFactor
    while let element = floorplan[safe: yFind]?[safe: xFind], element == "." {
        xFind += xFactor
        yFind += yFactor
    }
    return floorplan[safe: yFind]?[safe: xFind]
}

fileprivate extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    mutating func appendOrNil(_ element: Element?) {
        if let element = element { append(element) }
    }
}
