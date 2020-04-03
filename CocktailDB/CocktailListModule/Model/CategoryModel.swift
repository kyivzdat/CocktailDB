//
//  CategoryModel.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 31.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

typealias Codable = Decodable & Encodable

// MARK: - CategoryModel
struct CategoryModel: Codable {
    let drinks: [DrinkCategory]
}

// MARK: - CocktailCategory
struct DrinkCategory: Codable {
    let strCategory: String
    var isSelected: Bool! = true
    
    static func isEqual(fst: [DrinkCategory], snd: [DrinkCategory]) -> Bool {
        for index in 0..<fst.count {
            guard
                fst[index].strCategory == snd[index].strCategory,
                fst[index].isSelected == snd[index].isSelected
                else { return false }
        }
        return true
    }
}
