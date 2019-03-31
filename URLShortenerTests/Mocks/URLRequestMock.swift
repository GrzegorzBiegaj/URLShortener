//
//  URLRequestMock.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation
@testable import URLShortener

struct URLRequestMock: RequestProtocol {
    
    let url: String
    let statusCode: Int
    let error: Error?
    let data: Data?
    let httpMetodRequest: HTTPMethod?
    let body: [String: Any]?
       
    var endpoint: String { return url }
    
    init (url: String, statusCode: Int, error: Error? = nil, data: Data? = nil, httpMetodRequest: HTTPMethod? = nil, body: [String: Any]? = nil) {
        self.url = url
        self.statusCode = statusCode
        self.error = error
        self.data = data
        self.httpMetodRequest = httpMetodRequest
        self.body = body
    }
    
    var httpMethod: HTTPMethod {
        return httpMetodRequest ?? .get
    }
    
    var bodyParameters: BodyParameters {
        return body
    }
    
    var headers: Headers {
        return ["Content-Type": "application/json"]
    }
    
    var urlSession: URLSessionProtocol {
        return URLSessionTestMock(statusCode: statusCode, error: error, data: data)
    }
    let interpreter: ReadShortURLInterpreter = ReadShortURLInterpreter()
}
