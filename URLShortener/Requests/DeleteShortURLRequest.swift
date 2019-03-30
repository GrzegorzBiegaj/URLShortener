//
//  DeleteShortURLRequest.swift
//  URLShortener
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct DeleteShortURLRequest: RequestProtocol {
    
    var id: Int
    
    // MARK: Request protocol

    var endpoint: String { return "http://url-shortener.com/api/short/" + "\(String(id))" }
    
    var httpMethod: HTTPMethod {
        return .delete
    }
    
    var headers: Headers {
        return ["Content-Type": "application/json"]
    }
    
    let interpreter: WriteShortURLInterpreter = WriteShortURLInterpreter()
}
