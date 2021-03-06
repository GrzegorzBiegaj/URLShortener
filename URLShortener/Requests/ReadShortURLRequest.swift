//
//  ReadShortURLRequest.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct ReadShortURLRequest: RequestProtocol {
    
    // MARK: Request protocol
    
    var endpoint: String { return "http://url-shortener.com/api/short" }
    
    var headers: Headers {
        return ["Content-Type": "application/json"]
    }

    let interpreter: ReadShortURLInterpreter = ReadShortURLInterpreter()
}
