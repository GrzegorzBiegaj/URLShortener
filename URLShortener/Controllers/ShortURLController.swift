//
//  ShortURLController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class ShortURLController {
    
    var connection: RequestConnectionProtocol
    
    init (connection: RequestConnectionProtocol = RequestConnection()) {
        self.connection = connection
    }
    
    // MARK: Public interface
    
    func getShortURLData(handler: @escaping (Response<[ShortURL], ResponseError>) -> ()) {
        let request = ReadShortURLRequest()
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shortURLs):
                handler(.success(shortURLs))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    func storeShortURLData(url: String, handler: @escaping (Response<ShortURL, ResponseError>) -> ()) {
        let request = WriteShortURLRequest(url: url)
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shortURL):
                handler(.success(shortURL))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    func deleteShortURLData(id: Int, handler: @escaping (Response<ShortURL, ResponseError>) -> ()) {
        let request = DeleteShortURLRequest(id: id)
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shortURL):
                handler(.success(shortURL))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
}
