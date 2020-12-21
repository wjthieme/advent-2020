//
//  21.swift
//  Advent
//
//  Created by Wilhelm Thieme on 02/12/2020.
//

import Foundation

extension Solvers {
    @objc static let day21a: Solve = { input in
        let values = processInput(input)
        let allergens = findPotentiallyDangerousIngredients(values)
        var ingredients = values.flatMap({ $0.list })
        for (allergen, list) in allergens {
            ingredients.removeAll(where: { list.contains($0) })
        }
        
        return "\(ingredients.count)"
    }
    
    @objc static let day21b: Solve = { input in
        let values = processInput(input)
        let allergens = findPotentiallyDangerousIngredients(values)
        let dangerous = findDangerousIngredients(allergens)
        let sorted = dangerous.sorted(by: { $0.key < $1.key }).map({ $0.value })
        let result = sorted.joined(separator: ",")
        return "\(result)"
    }
}

fileprivate func processInput(_ string: String) -> [Ingredients] {
    let lines = string.components(separatedBy: "\n")
    return lines.compactMap({ Ingredients($0) })
}

fileprivate class Ingredients {
    let list: [String]
    let allergens: [String]
    
    init?(_ string: String) {
        let parts = string.components(separatedBy: " (contains ")
        if parts.isEmpty {
            list = string.components(separatedBy: " ")
            allergens = []
        } else if parts.count > 1 {
            list = parts[0].components(separatedBy: " ")
            allergens = parts[1].replacingOccurrences(of: ")", with: "").components(separatedBy: ", ")
        } else {
            return nil
        }
    }
}

fileprivate func findPotentiallyDangerousIngredients(_ ingredients: [Ingredients]) -> [String: Set<String>] {
    var allergens = [String: Set<String>]()
    for ingredient in ingredients {
        for allergen in ingredient.allergens {
            if let val = allergens[allergen] {
                allergens[allergen] = val.intersection(ingredient.list)
            } else {
                allergens[allergen] = Set(ingredient.list)
            }
        }
    }
    return allergens
}

fileprivate func findDangerousIngredients(_ possibleIngredients: [String: Set<String>]) -> [String: String] {
    var new = possibleIngredients
    while new.contains(where: { $0.value.count != 1 }) {
        for n in new.keys {
            for i in new.keys {
                if new[i]?.count == 1 && n != i, let first = new[i]?.first {
                    new[n]?.remove(first)
                }
            }
        }
    }
    
    return new.mapValues { $0.first! }
}
