//
//  NetworkResponseHandler.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 02.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Moya
import Foundation

protocol ResponseHandlerProtocol {
    
    func handle<T: Codable>(response: Result<Response, MoyaError>, completion: @escaping(T?, Error?) ->())
}

final class NetworkResponseHander: ResponseHandlerProtocol {
    
    func handle<T: Codable>(response: Result<Response, MoyaError>, completion: @escaping(T?, Error?) ->()) {
        switch response {
        case .success(let value):
            do {
                let result = try JSONDecoder().decode(T.self, from: value.data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}
