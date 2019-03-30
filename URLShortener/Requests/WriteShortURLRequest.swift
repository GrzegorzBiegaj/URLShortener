//
//  WriteShortURLRequest.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct WriteShortURLRequest: RequestProtocol {
    
    let url: String
    
    // MARK: Request protocol
    
    var endpoint: String { return "http://url-shortener.com/api/short" }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var headers: Headers {
        return ["Content-Type": "application/json"]
    }
    
    var bodyParameters: BodyParameters {
        return ["url": url]
    }
    
    let interpreter: WriteShortURLInterpreter = WriteShortURLInterpreter()
}
