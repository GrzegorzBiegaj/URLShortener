//
//  Types.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

typealias RequestParameters = [String: Any]?

typealias BodyParameters = [String: Any]?

typealias Headers = [String: String]?

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ResponseError: Error {
    case invalidResponseError
    case decodeError
    case wrongUrlKey
    case noUrl
    case wrongUrlScheme
    case urlAlreadyExists
    case idNotFound
    case invalidRequest
    case unknownError
    
    var errorDescription: String {
        switch self {
        case .invalidResponseError: return "Invalid response Error"
        case .decodeError: return "Data decode error"
        case .wrongUrlKey: return "Wrong URL key"
        case .noUrl: return "URL not found"
        case .wrongUrlScheme: return "Wrong URL scheme, only http and https schemes are supported"
        case .urlAlreadyExists: return "URL already exists"
        case .idNotFound: return "Short URL id not found"
        case .invalidRequest: return "Invalid request"
        case .unknownError: return "Unknown error"

        }
    }
}
