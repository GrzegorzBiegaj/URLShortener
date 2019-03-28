//
//  InterpreterProtocol.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

protocol NetworkResponseInterpreter {
    associatedtype SuccessType
    associatedtype ErrorType: Error
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<SuccessType, ErrorType>
}
