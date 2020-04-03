//
//  NetworkAPI.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 02.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Moya
import Foundation

enum NetworkAPI {
    
    case categories
    case cocktailOf(_ category: String)
}

extension NetworkAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "list.php"
        case .cocktailOf:
            return "filter.php"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .categories:
            return .requestParameters(parameters: ["c": "list"], encoding: URLEncoding.queryString)
        case .cocktailOf(let category):
            return .requestParameters(parameters: ["c": category], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
