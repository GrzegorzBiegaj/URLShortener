//
//  MockURLSession.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    
    static let shared = MockURLSession()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let dataResult = MockURLHandler().handleData(request: request)
        completionHandler(dataResult.data, dataResult.response, dataResult.error)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {

    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}
