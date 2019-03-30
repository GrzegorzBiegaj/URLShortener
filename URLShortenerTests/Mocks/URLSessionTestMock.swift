//
//  URLSessionMock.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation
@testable import URLShortener

class URLSessionTestMock: URLSessionProtocol {

    let statusCode: Int
    let error: Error?
    let data: Data?
    
    init (statusCode: Int, error: Error? = nil, data: Data? = nil) {
        self.statusCode = statusCode
        self.error = error
        self.data = data
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let urlHandlerTestMock = URLHandlerTestMock(statusCode: statusCode, error: error, data: data)
        urlHandlerTestMock.handleData(request: request, completionHandler: completionHandler)
        return MockURLSessionDataTask()
    }
}

class URLHandlerTestMock {

    let statusCode: Int
    let error: Error?
    let data: Data?
    
    init (statusCode: Int, error: Error? = nil, data: Data? = nil) {
        self.statusCode = statusCode
        self.error = error
        self.data = data
    }
    
    func handleData(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields)
        completionHandler(data, response, error)
    }

}
