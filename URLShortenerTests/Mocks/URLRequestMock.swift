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
       
    var endpoint: String { return url }
    
    var headers: Headers {
        return ["Content-Type": "application/json"]
    }
    
    var urlSession: URLSessionProtocol {
        return URLSessionTestMock(statusCode: statusCode, error: error, data: data)
    }
    let interpreter: ReadShortURLInterpreter = ReadShortURLInterpreter()
}
