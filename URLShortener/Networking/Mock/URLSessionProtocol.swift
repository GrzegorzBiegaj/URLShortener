//
//  URLSessionProtocol.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    
    static var shared: URLSessionProtocol { get }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
