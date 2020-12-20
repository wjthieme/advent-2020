//
//  20.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day20a: Solve = { input in
        let values = processInput(input)
        let left = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsLeft(with: second) }).count > 0 }))
        let right = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsRight(with: second) }).count > 0 }))
        let top = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsTop(with: second) }).count > 0 }))
        let bottom = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsBottom(with: second) }).count > 0 }))
        let corners = values.filter { [left.contains($0), right.contains($0), top.contains($0), bottom.contains($0)].filter({ $0 }).count == 2  }
        let result = corners.map({ $0.id }).reduce(1, *)
        return "\(result)"
    }
    
    @objc static let day20b: Solve = { input in
        var values = Set(processInput(input))
        let dim = Int(sqrt(Double(values.count)))
        let left = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsLeft(with: second) }).count > 0 }))
        let top = Set(values.filter({ first in values.filter({ second in first != second }).filter({ second in first.pairsTop(with: second) }).count > 0 }))
        guard let topLeft = values.first(where: { !left.contains($0) && !top.contains($0) }) else { return "0" }
        var tiles = [TileConfig](repeating: TileConfig(), count: values.count)
        tiles[0] = TileConfig(tile: topLeft)
        values.remove(topLeft)
        for n in 1..<tiles.count {
            var configs = values.flatMap({ TileConfig.allConfigurations($0) })
            if n % dim > 0 { configs = configs.filter({ $0.pairsLeft(with: tiles[n-1] )}) }
            if n > dim-1 { configs = configs.filter({ $0.pairsTop(with: tiles[n-dim] )}) }
            guard let first = configs.first else { return "0" }
            tiles[n] = first
            values.remove(first.tile)
        }
        
        var image: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 96), count: 96)
        for n in 0..<tiles.count {
            for y in 0..<tiles[n].core.count {
                for x in 0..<tiles[n].core[y].count {
                    let iX = n % dim * tiles[n].core.count + x
                    let iY = n / dim * tiles[n].core.count + y
                    image[iY][iX] = tiles[n].core[y][x]
                }
            }
            
        }
        
        var transformed = [image]
        transformed.append(image.reversed())
        transformed.append(image.map({ $0.reversed() }))
        transformed.append(image.reversed().map({ $0.reversed() }))
        transformed.append(image.transposed())
        transformed.append(image.reversed().transposed())
        transformed.append(image.map({ $0.reversed() }).transposed())
        transformed.append(image.reversed().map({ $0.reversed() }).transposed())
        
        let monster = [(0, 18), (1, 5), (1, 6), (1, 11), (1, 12), (1, 17), (1, 18), (1, 19), (2, 1), (2, 4), (2, 7), (2, 10), (2, 13), (2, 16)]
        var monsterCount = 0
        for i in 0..<transformed.count {
            for y in 0..<transformed[i].count {
                for x in 0..<transformed[i][y].count {
                    if x+20 > transformed[i][y].count { continue }
                    if y+3 > transformed[i].count { continue }
                    let values = monster.map({ transformed[i][y+$0.0][x+$0.1] })
                    if !values.contains(0) {
                        monster.forEach({ transformed[i][y+$0.0][x+$0.1] = 2 })
                        monsterCount += 1
                    }
                }
            }
        }
        let roughness = image.flatMap({ $0 }).filter({ $0 == 1 }).count - monsterCount * 15
        return "\(roughness)"
    }
}

fileprivate func processInput(_ string: String) -> [Tile] {
    let blocks = string.components(separatedBy: "\n\n")
    return blocks.compactMap({ Tile($0) })
}

fileprivate class TileConfig: CustomStringConvertible {
    let tile: Tile
    private let orientation: Int
    private let hFlipped: Bool
    private let vFlipped: Bool
    
    var description: String { return "\(tile) (orientation: \(orientation), hFlipped: \(hFlipped), vFlipped: \(vFlipped))" }
    
    private lazy var t = { [tile.top, tile.right, tile.bottom, tile.left][(0+orientation) % 4]  }()
    private lazy var r = { [tile.top, tile.right, tile.bottom, tile.left][(1+orientation) % 4]  }()
    private lazy var b = { [tile.top, tile.right, tile.bottom, tile.left][(2+orientation) % 4]  }()
    private lazy var l = { [tile.top, tile.right, tile.bottom, tile.left][(3+orientation) % 4]  }()
    lazy var top = { vFlipped ? (hFlipped ? b : b.reversed()) : (hFlipped ? t.reversed() : t) }()
    lazy var bottom = { vFlipped ? (hFlipped ? t : t.reversed()) : (hFlipped ? b.reversed() : b) }()
    lazy var left = { hFlipped ? (vFlipped ? r : r.reversed()) : (vFlipped ? l.reversed() : l) }()
    lazy var right = { hFlipped ? (vFlipped ? l : l.reversed()) : (vFlipped ? r.reversed() : r) }()
    lazy var core: [[Int]] = {
        var c = tile.core
        if orientation == 1 {
            c = c.transposed()
            c = c.reversed()
        }
        if hFlipped {
            c = c.map({ $0.reversed() })
        }
        if vFlipped {
            c = c.reversed()
        }
        return c
    }()
    
    init(tile: Tile = Tile(), orientation: Int = 0, hFlipped: Bool = false, vFlipped: Bool = false) {
        self.tile = tile
        self.orientation = orientation
        self.hFlipped = hFlipped
        self.vFlipped = vFlipped
    }
    
    func pairsLeft(with other: TileConfig) -> Bool { left.reversed() == other.right }
    func pairsRight(with other: TileConfig) -> Bool { right.reversed() == other.left }
    func pairsTop(with other: TileConfig) -> Bool { top.reversed() == other.bottom }
    func pairsBottom(with other: TileConfig) -> Bool { bottom.reversed() == other.top }
    
    static func allConfigurations(_ tile: Tile) -> [TileConfig] {
        return (0..<2).flatMap({ o in [true, false].flatMap({ h in [true, false].map({ v in TileConfig(tile: tile, orientation: o, hFlipped: h, vFlipped: v) }) })  })
    }
}

fileprivate class Tile: Hashable, CustomStringConvertible {
    static func == (lhs: Tile, rhs: Tile) -> Bool { return lhs.id == rhs.id }

    let id: Int
    let image: [Int]
    
    lazy var dimension = { return Int(sqrt(Double(image.count))) }()
    lazy var top: [Int] = { return stride(from: 0, to: dimension, by: 1).map({ image[$0] }) }()
    lazy var right: [Int] = { return stride(from: dimension-1, to: image.count, by: dimension).map({ image[$0] }) }()
    lazy var bottom: [Int] = { return stride(from: image.count-dimension, to: image.count, by: 1).map({ image[$0] }).reversed() }()
    lazy var left: [Int] = { return stride(from: 0, through: image.count-dimension, by: dimension).map({ image[$0] }).reversed() }()
    lazy var sides: Set<[Int]> = { return [top, top.reversed(), bottom, bottom.reversed(), left, left.reversed(), right, right.reversed()] }()
    lazy var core: [[Int]] = { return (1..<dimension-1).flatMap({ f in (1..<dimension-1).map({ s in s + f * dimension }) }).map({ image[$0] }).chunked(dimension-2) }()
    
    var description: String { return "\(id)" }
    
    init?(_ string: String) {
        let lines = string.components(separatedBy: "\n")
        guard let first = lines.first else { return nil }
        guard let id = Int(first.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)) else { return nil }
        self.id = id
        self.image = lines.dropFirst().joined().map({ $0 == "#" ? 1 : 0 })
    }
    
    init() { self.id = -1; self.image = [] }
    
    func pairsLeft(with other: Tile) -> Bool { return other.sides.intersection([left, left.reversed()]).count > 0 }
    func pairsRight(with other: Tile) -> Bool { return other.sides.intersection([right, right.reversed()]).count > 0 }
    func pairsTop(with other: Tile) -> Bool { return other.sides.intersection([top, top.reversed()]).count > 0 }
    func pairsBottom(with other: Tile) -> Bool { return other.sides.intersection([bottom, bottom.reversed()]).count > 0 }
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

fileprivate extension Array {
    func chunked(_ size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

fileprivate extension Collection where Iterator.Element: RandomAccessCollection {
    func transposed() -> [[Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}
