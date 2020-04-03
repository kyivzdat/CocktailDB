//
//  CocktailListPresenter.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 03.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

protocol CocktailListView: class {
    
    func gotCocktailCategories(error: Error?)
    func gotCocktails(completion: (() -> ())?, error: Error?)
    func didChangedPrintCategories(withLoadNewCocktails isLoading: Bool)
}

protocol CocktailListViewPresenter: class {
    
    var networkManager:     NetworkManager { get }
    var categoriesTitles:   [String] { get set }
    var printCategories:    [String]? { get set }
    var cocktails:          [String: [Drink]] { get set }
    
    init(_ view: CocktailListView)
    func getCocktailCategories()
    func getCocktailOf(_ category: String, completion: (() -> ())?)
    func performPagination(for row: Int, section: Int) -> Bool
    func getCategoriesWithStatus() -> [DrinkCategory]
}

final class CocktailListPresenter: CocktailListViewPresenter {
    
    // MARK: - Properties
    unowned var view: CocktailListView
    let networkManager = NetworkManager()
    /// List of all cocktails categories
    var categoriesTitles: [String] = [] {
        didSet {
            printCategories = categoriesTitles
            guard let firstCategory = categoriesTitles.first else { return }
            // Get here once when viewDidload
            getCocktailOf(firstCategory)
        }
    }
    var printCategories: [String]? {
        didSet {
            if oldValue != nil, oldValue != printCategories {
                if let category = printCategories?.first, cocktails[category] == nil {
                    getCocktailOf(category) {}
                    self.view.didChangedPrintCategories(withLoadNewCocktails: true)
                } else {
                    self.view.didChangedPrintCategories(withLoadNewCocktails: false)
                }
            }
        }
    }
    var cocktails: [String: [Drink]] = [:]
    
    required init(_ view: CocktailListView) {
        self.view = view
    }
    
    // MARK: - Methods
    func getCocktailCategories() {
        networkManager.getCategories { (categoryModel, error) in
            
            if let error = error {
                print(error)
                self.view.gotCocktailCategories(error: error)
            }
            guard let categories = categoryModel?.drinks else { return }
            self.categoriesTitles = categories.map({ $0.strCategory })
            self.view.gotCocktailCategories(error: nil)
        }
    }
    
    func getCocktailOf(_ category: String, completion: (() -> ())? = nil) {
        networkManager.getCocktailsOf(category) { (drinkModel, error) in
            
            if let error = error {
                self.view.gotCocktails(completion: nil, error: error)
            }
            guard let drinks = drinkModel?.drinks else { return }
            self.cocktails[category] = drinks
            
            self.view.gotCocktails(completion: completion, error: nil)
        }
    }
    
    func getCategoriesWithStatus() -> [DrinkCategory] {
        guard let printCategories = printCategories else { return  [] }
        var result: [DrinkCategory] = []
        for category in categoriesTitles {
            let newCategory = DrinkCategory(strCategory: category,
                                            isSelected: printCategories.contains(category))
            result.append(newCategory)
        }
        return result
    }
    
    func performPagination(for row: Int, section: Int) -> Bool {
        // Check to prevent segfault in printCategories
        guard let category = printCategories?[section],
        let numberOfprintCategories = printCategories?.count,
        section < numberOfprintCategories - 1,
        
        // Check to update pagination
        let currentCocktails = cocktails[category],
        row == currentCocktails.count - 1,
        
        // Check for the presence of a category in [cocktails],
        // to load each category once
        let newCategory = printCategories?[section + 1],
            !cocktails.keys.contains(newCategory)
            else { return false }
        cocktails[newCategory] = []
        getCocktailOf(newCategory, completion: nil)
        return true
    }
}
