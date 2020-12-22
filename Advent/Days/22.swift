//
//  22.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day22a: Solve = { input in
        let (deck1, deck2) = processInput(input)
        let (final1, final2) = playCombat(with: deck1, and: deck2)
        let final = (final1 + final2)
        let mults = final.enumerated().map({ $0.element * (final.count - $0.offset) })
        let sum = mults.reduce(0, +)
        return "\(sum)"
    }
    
    @objc static let day22b: Solve = { input in
        let (deck1, deck2) = processInput(input)
        let (final1, final2) = playRecursiveCombat(with: deck1, and: deck2)
        let final = (final1 + final2)
        let mults = final.enumerated().map({ $0.element * (final.count - $0.offset) })
        let sum = mults.reduce(0, +)
        return "\(sum)"
    }
}

fileprivate func processInput(_ string: String) -> ([Int], [Int]) {
    let lines = string.components(separatedBy: "\n\n")
    guard lines.count > 1 else { return ([], [])}
    let first = lines[0].components(separatedBy: "\n").dropFirst().compactMap({ Int($0) })
    let second = lines[1].components(separatedBy: "\n").dropFirst().compactMap({ Int($0) })
    return (first, second)
}

fileprivate func playCombat(with deck1: [Int], and deck2: [Int]) -> ([Int], [Int]) {
    var (deck1, deck2) = (deck1, deck2)
    while let card1 = deck1.first, let card2 = deck2.first {
        deck1.remove(at: 0)
        deck2.remove(at: 0)
        if card1 > card2 {
            deck1.append(card1)
            deck1.append(card2)
        } else if card1 < card2 {
            deck2.append(card2)
            deck2.append(card1)
        } else {
            deck1.append(card2)
            deck2.append(card1)
        }
    }
    return (deck1, deck2)
}

fileprivate func playRecursiveCombat(with deck1: [Int], and deck2: [Int]) -> ([Int], [Int]) {
    var (deck1, deck2) = (deck1, deck2)
    var previous = Set<[[Int]]>()
    while let card1 = deck1.first, let card2 = deck2.first {
        if previous.contains([deck1, deck2]) { deck2 = []; break }
        previous.insert([deck1, deck2])
        
        deck1.remove(at: 0)
        deck2.remove(at: 0)
        var winner = 0
        
        if deck1.count >= card1 && deck2.count >= card2 {
            let range1 = 0..<card1
            let range2 = 0..<card2
            let (sub1, sub2) = playRecursiveCombat(with: Array(deck1[range1]), and: Array(deck2[range2]))
            if sub1.count > sub2.count { winner = 1 }
            if sub1.count < sub2.count { winner = 2 }
        } else {
            if card1 > card2 { winner = 1 }
            if card1 < card2 { winner = 2 }
        }
        
        switch winner {
        case 1:
            deck1.append(card1)
            deck1.append(card2)
        case 2:
            deck2.append(card2)
            deck2.append(card1)
        default:
            deck1.append(card2)
            deck2.append(card1)
        }
    }
    return (deck1, deck2)
}


