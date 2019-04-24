//
//  ReadShortURLInterpreter.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class ReadShortURLInterpreter: NetworkResponseInterpreter {
     
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Result<[ShortURL], ResponseError> {
        
        if let error = error { return Result.failure(error as? ResponseError ?? .unknownError) }
        guard response?.statusCode == successStatusCode else {
            return Result.failure(ResponseError.invalidResponseError)
        }
        guard let data = data else { return Result.failure(ResponseError.invalidResponseError) }
        guard let response = try? JSONDecoder().decode([ShortURL].self, from: data) else {
            return Result.failure(ResponseError.decodeError)
        }
        return Result.success(response)
    }
}
