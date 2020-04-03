//
//  CategoriesListPresenter.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 03.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

protocol CategoriesListView: class {
    func changedColorButton(isActive: Bool)
}

protocol CategoriesListViewPresenter: class {

    var oldCategories: [DrinkCategory] { get set }
    var newCategories: [DrinkCategory]! { get set }
    
    init(_ view: CategoriesListView, categories: [DrinkCategory])
    
    func getSelectedCategories() -> [String]
}

final class CategoriesListPresenter: CategoriesListViewPresenter {
    
    unowned var view: CategoriesListView
    var oldCategories: [DrinkCategory]
    var newCategories: [DrinkCategory]! {
        didSet {
            guard oldValue != nil else { return }
            let isIdentical = DrinkCategory.isEqual(fst: oldCategories, snd: newCategories)
            view.changedColorButton(isActive: !isIdentical)
        }
    }
    
    required init(_ view: CategoriesListView, categories: [DrinkCategory]) {
        self.view = view
        self.oldCategories = categories
        newCategories = oldCategories
    }
    
    func getSelectedCategories() -> [String] {
        let categories = Array(newCategories)
        var selectedCategories: [String] = []
        for category in categories {
            guard category.isSelected else { continue }
            selectedCategories.append(category.strCategory)
        }
        return selectedCategories
    }
}
