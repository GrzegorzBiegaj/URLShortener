//
//  WriteShortenerInterpreter.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class WriteShortenerInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<Shortener, ResponseError> {
        
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        if let error = error as NSError? {
            switch error.code {
            case 100:
                return Response.error(ResponseError.noUrl)
            case 101:
                return Response.error(ResponseError.wrongUrlKey)
            case 102:
                return Response.error(ResponseError.wrongUrlScheme)
            case 103:
                return Response.error(ResponseError.urlAlreadyExists)
            default:
                return Response.error(ResponseError.unknownError)
            }
        }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        guard let response = try? JSONDecoder().decode(Shortener.self, from: data) else {
            return Response.error(ResponseError.decodeError)
        }
        return Response.success(response)
    }
}
