//
//  NetworkManager.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 02.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Moya
import Foundation

final class NetworkManager {
    
    private var provider: MoyaProvider<NetworkAPI>
    private var responseHandler: ResponseHandlerProtocol
    
    init(_ provider: MoyaProvider<NetworkAPI> = MoyaProvider<NetworkAPI>(),
         _ responseHandler: ResponseHandlerProtocol = NetworkResponseHander()) {
        
        self.provider = provider
        self.responseHandler = responseHandler
    }
    
    func getCategories(completion: @escaping(CategoryModel?, Error?) -> ()) {
        provider.request(.categories) { (response) in
            self.responseHandler.handle(response: response, completion: completion)
        }
    }
    
    func getCocktailsOf(_ category: String, completion: @escaping(DrinkModel?, Error?) -> ()) {
        provider.request(.cocktailOf(category)) { (response) in
            self.responseHandler.handle(response: response, completion: completion)
        }
    }
}
