//
//  MockURLHandler.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class MockURLHandler {
    
    struct DataResult {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    func handleData(request: URLRequest) -> DataResult {
        var statusCode = 200
        var error: Error?
        var data: Data?
        
        guard let url = request.url else { return DataResult(data: nil, response: nil, error: nil) }
        
        switch request.httpMethod {
        case HTTPMethod.get.rawValue:
            data = restore()
        case HTTPMethod.post.rawValue:
            if let data = request.httpBody {
                store(data: data)
            } else {
                statusCode = 400
                error = NSError(domain: "URL not found", code: statusCode, userInfo: nil)
            }
        case HTTPMethod.delete.rawValue:
            break
        default:
            statusCode = 400
            error = NSError(domain: "Invalid request", code: statusCode, userInfo: nil)
            break
        }
        
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields)
        
        return DataResult(data: data, response: response,   error: error)
    }
    
    fileprivate func store(data: Data?) {
        
    }
    
    fileprivate func restore() -> Data? {
        return nil
    }
}
