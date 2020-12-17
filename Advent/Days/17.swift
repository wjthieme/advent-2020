//
//  17.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation
import Accelerate

@available(OSX 11.0, *)
extension Solvers {
    @objc static let day17a: Solve = { input in
        let values = processInput(input)
        let dim = Int(sqrt(Double(values.count)))
        var grid = Grid(values.map({ Int8($0) }), [1, dim, dim]).pad()
        for n in 0..<6 {
            grid = grid.pad()
            grid = grid.convolve()
        }
        return "\(grid.activeCount)"
    }
    
    @objc static let day17b: Solve = { input in

        return "0"
    }
}

//typealias Grid = [[[Bool]]]

fileprivate func processInput(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: "\n")
    return lines.flatMap( { $0.map({ $0 == "#" ? 1 : 0 }) })
}

//fileprivate let kernel = configurations(Array(-1...1), 3).filter { $0 != [0, 0, 0] }

@available(OSX 11.0, *)
fileprivate class Grid {
    private let values: [Int8]
    private let size: [Int]
    private var layout: BNNS.DataLayout {
        switch size.count {
        case 2: return .matrixFirstMajor
        case 3: return .tensor3DFirstMajor
        case 4: return .tensor4DFirstMajor
        case 5: return .tensor5DFirstMajor
        case 6: return .tensor6DFirstMajor
        case 7: return .tensor7DFirstMajor
        case 8: return .tensor8DFirstMajor
        default: return .vector
        }
    }
    private var shape: BNNS.Shape { return BNNS.Shape(size, dataLayout: layout) }

    init(_ values: [Int8], _ size: [Int]) {
        self.values = values
        self.size = size
    }
    
    func pad(by pad: Int = 1) -> Grid {
        let newSize = Array(size).map { $0 + pad * 2 }
        let newShape = BNNS.Shape(newSize, dataLayout: layout)
        let padding = (0..<size.count).map({ _ in (pad, pad) }) + (0..<8-size.count).map({ _ in (0, 0) })
        var new = [Int8](repeating: 0, count: values.count)
        
        let p = padding.withUnsafeBytes { buf in
          return buf.bindMemory(to: ((Int, Int), (Int, Int), (Int, Int), (Int, Int), (Int, Int), (Int, Int), (Int, Int), (Int, Int)).self)[0]
        }
        
        let srcDesc = BNNSNDArrayDescriptor(dataType: .int8, shape: shape)
        let desDesc = BNNSNDArrayDescriptor(dataType: .int8, shape: newShape)
        var layerParams = BNNSLayerParametersPadding(i_desc: srcDesc, o_desc: desDesc, padding_size: p, padding_mode: BNNSPaddingModeConstant, padding_value: 0)
        var filterParams = BNNSFilterParameters()
        let filter = BNNSFilterCreateLayerPadding(&layerParams, &filterParams)
        defer { BNNSFilterDestroy(filter) }
        BNNSFilterApply(filter, values, &new)
        return Grid(new, newSize)
    }
    
    func convolve() -> Grid {
//        var new = values
//        for n in 0..<values.count {
//            let i = indices(for: n)
//            let ind = zip([[Int]](repeating: i, count: kernel.count), kernel).map(+)
//            let sum = ind.map({ self[$0] }).reduce(0, +)
//            if self[i] == 1 && !(2...3).contains(sum) {
//                new[n] = 0
//            } else if self[i] == 0 && sum == 3 {
//                new[n] = 1
//            }
//        }
//        return Grid(new, shape)
        return self
    }
    
    var activeCount: Int { return values.filter({ $0 == 1 }).count }
}

//fileprivate extension Grid {
//    
//    
//    func pad() -> Grid {
//        var new = self
//
//        for z in 0..<dim1 {
//            for y in 0..<dim2 {
//                new[z][y].insert(false, at: 0)
//                new[z][y].insert(false, at: 0)
//                new[z][y].append(false)
//                new[z][y].append(false)
//            }
//            new[z].insert(.init(repeating: false, count: dim3+4), at: 0)
//            new[z].insert(.init(repeating: false, count: dim3+4), at: 0)
//            new[z].append(.init(repeating: false, count: dim3+4))
//            new[z].append(.init(repeating: false, count: dim3+4))
//        }
//        
//        new.insert(.init(repeating: .init(repeating: false, count: dim2+4), count: dim3+4), at: 0)
//        new.insert(.init(repeating: .init(repeating: false, count: dim2+4), count: dim3+4), at: 0)
//        new.append(.init(repeating: .init(repeating: false, count: dim2+4), count: dim3+4))
//        new.append(.init(repeating: .init(repeating: false, count: dim2+4), count: dim3+4))
//        
//        return new
//    }
//}
//
//fileprivate func configurations(_ options: [Int], _ maxCount: Int, _ partial: [Int] = []) -> [[Int]] {
//    if partial.count == maxCount { return [partial] }
//    return options.flatMap({ configurations(options, maxCount, partial + [$0]) })
//}

