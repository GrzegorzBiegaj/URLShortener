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
        let headerFields: [String : String]? = nil
        
        guard let url = request.url else { return DataResult(data: nil, response: nil, error: nil) }
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headerFields)
        
        switch request.httpMethod {
        case HTTPMethod.get.rawValue:
            break
        case HTTPMethod.post.rawValue:
            break
        case HTTPMethod.delete.rawValue:
            break
        default:
            statusCode = 500
            break
        }
        return DataResult(data: nil, response: response, error: nil)
    }
}
