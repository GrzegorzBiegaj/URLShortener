//
//  ReadShortenerInterpreter.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class ReadShortenerInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<[Shortener], ResponseError> {
        
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        if let _ = error { return Response.error(ResponseError.invalidResponseError) }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        guard let response = try? JSONDecoder().decode([Shortener].self, from: data) else {
            return Response.error(ResponseError.decodeError)
        }
        return Response.success(response)
    }
}
