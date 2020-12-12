//
//  12.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day12a: Solve = { input in
        let instructions = processInput(input)
        let position = CurrentPosition()
        instructions.forEach { position.processInstruction(withHeading: $0) }
        return "\(position.distance)"
    }
    
    @objc static let day12b: Solve = { input in
        let instructions = processInput(input)
        let position = CurrentPosition()
        instructions.forEach { position.processInstruction(withWaypoint: $0) }
        return "\(position.distance)"
    }
}

fileprivate func processInput(_ string: String) -> [Instruction] {
    let lines = string.components(separatedBy: "\n")
    return lines.compactMap { Instruction($0) }
}


fileprivate class CurrentPosition {
    var heading: Heading = .east
    var shipX: Int = 0
    var shipY: Int = 0
    var waypointX: Int = 10
    var waypointY: Int = 1
    
    init() { }
    
    func processInstruction(withHeading instruction: Instruction) {
        switch instruction.heading {
        case .north: shipY += instruction.distance
        case .east: shipX += instruction.distance
        case .south: shipY -= instruction.distance
        case .west: shipX -= instruction.distance
        case .forward: processInstruction(withHeading: Instruction(heading, instruction.distance))
        case .backwards: processInstruction(withHeading: Instruction(heading.L180, instruction.distance))
        case .left:
            switch instruction.distance % 360 {
            case 90: heading = heading.L90
            case 180: heading = heading.L180
            case 270: heading = heading.L270
            default: break
            }
        case .right:
            switch instruction.distance % 360 {
            case 90: heading = heading.R90
            case 180: heading = heading.R180
            case 270: heading = heading.R270
            default: break
            }
        }
    }
    
    func processInstruction(withWaypoint instruction: Instruction) {
        switch instruction.heading {
        case .north: waypointY += instruction.distance
        case .east: waypointX += instruction.distance
        case .south: waypointY -= instruction.distance
        case .west: waypointX -= instruction.distance
        case .forward:
            shipX += waypointX * instruction.distance
            shipY += waypointY * instruction.distance
        case .backwards:
            shipX -= waypointX * instruction.distance
            shipY -= waypointY * instruction.distance
        case .left:
            let angle = CGFloat(instruction.distance % 360) * (CGFloat.pi/180)
            let point = CGPoint(x: waypointX, y: waypointY).applying(.init(rotationAngle: angle))
            waypointX = Int(round(point.x))
            waypointY = Int(round(point.y))
        case .right:
            let angle = CGFloat(360 - instruction.distance % 360) * (CGFloat.pi/180)
            let point = CGPoint(x: waypointX, y: waypointY).applying(.init(rotationAngle: angle))
            waypointX = Int(round(point.x))
            waypointY = Int(round(point.y))
        }
    }
    
    var distance: Int { return abs(shipX) + abs(shipY) }
}

fileprivate class Instruction {
    let heading: Heading
    let distance: Int
    
    convenience init?(_ str: String) {
        guard let head = Heading(rawValue: str[str.startIndex]) else { return nil }
        let split = str.index(str.startIndex, offsetBy: 1)
        guard let dist = Int(str[split..<str.endIndex]) else { return nil }
        self.init(head, dist)
    }
    
    init(_ head: Heading, _ dist: Int) {
        heading = head
        distance = dist
    }
}

fileprivate enum Heading: Character {
    case north = "N"
    case east = "E"
    case south = "S"
    case west = "W"
    case forward = "F"
    case backwards = "B"
    case left = "L"
    case right = "R"
    
    
    var L90: Heading {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        default: return self
        }
    }
    var L180: Heading { return L90.L90 }
    var L270: Heading { return L180.L90 }
    var R90: Heading { return L270 }
    var R180: Heading { return L180 }
    var R270: Heading { return L90 }
}
