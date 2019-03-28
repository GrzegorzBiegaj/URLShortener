//
//  RequestProtocol.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlSession: URLSessionProtocol { get }
    var successStatusCode: Int { get }
    var httpMethod: HTTPMethod { get }
    var endpoint: String { get }
    var requestParameters: RequestParameters { get }
    var bodyParameters: BodyParameters { get }
    var headers: Headers { get }
    
    associatedtype InterpreterType: NetworkResponseInterpreter
    var interpreter: InterpreterType { get }
}

extension RequestProtocol {
    var urlSession: URLSessionProtocol { return MockURLSession.shared }
    var successStatusCode: Int { return 200 }
    var httpMethod: HTTPMethod { return .get }
    var requestParameters: RequestParameters { return nil }
    var bodyParameters: BodyParameters { return nil }
    var headers: Headers { return nil }
}

