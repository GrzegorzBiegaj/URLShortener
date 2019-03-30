//
//  DeleteShortURLInterpreter.swift
//  URLShortener
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class DeleteShortURLInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<ShortURL, ResponseError> {
        
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        if let error = error as NSError? {
            switch error.code {
            case 110:
                return Response.error(ResponseError.idNotFound)
            default:
                return Response.error(ResponseError.unknownError)
            }
        }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        guard let response = try? JSONDecoder().decode(ShortURL.self, from: data) else {
            return Response.error(ResponseError.decodeError)
        }
        return Response.success(response)
    }
}
