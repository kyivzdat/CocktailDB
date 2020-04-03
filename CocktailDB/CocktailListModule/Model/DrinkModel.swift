//
//  DrinkModel.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 31.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

// MARK: - DrinkModel
struct DrinkModel: Codable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
