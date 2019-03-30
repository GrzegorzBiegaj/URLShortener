//
//  ShortenerController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class ShortenerController {
    
    var connection: RequestConnectionProtocol
    
    init (connection: RequestConnectionProtocol = RequestConnection()) {
        self.connection = connection
    }
    
    func getShortenerData(handler: @escaping (Response<[ShortURL], ResponseError>) -> ()) {
        let request = ReadShortenerRequest()
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shorteners):
                handler(.success(shorteners))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    func storeShortenerData(url: String, handler: @escaping (Response<ShortURL, ResponseError>) -> ()) {
        let request = WriteShortenerRequest(url: url)
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shortener):
                handler(.success(shortener))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    func deleteShortenerData(id: Int, handler: @escaping (Response<ShortURL, ResponseError>) -> ()) {
        let request = DeleteShortenerRequest(id: id)
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let shortener):
                handler(.success(shortener))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
}
