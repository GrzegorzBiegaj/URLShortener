//
//  RequestConnection.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

protocol RequestConnectionProtocol {
    
    func performRequest<Req: RequestProtocol>(request: Req, handler: @escaping (Result<Req.InterpreterType.SuccessType, Req.InterpreterType.ErrorType>) -> Void)
}

class RequestConnection: RequestConnectionProtocol {
    
    // MARK: Configuration

    let connectionTimeout = 10.0
    
    // MARK: Public interface
    
    func performRequest<Req: RequestProtocol>(request: Req, handler: @escaping (Result<Req.InterpreterType.SuccessType, Req.InterpreterType.ErrorType>) -> Void) {
        
        guard let url = computeURL(request) else { return }
        guard let urlRequest = setupURLRequest(request, url: url) else { return }
        
        let task = request.urlSession.dataTask(with: urlRequest) { data, res, error in

            let response = request.interpreter.interpret(data: data, response: res as? HTTPURLResponse, error: error, successStatusCode: request.successStatusCode)

            self.connectionLog(request)
            DispatchQueue.main.async {
                handler(response)
            }
        }
        task.resume()
    }
    
    // MARK: private methods
    
    fileprivate func setupURLRequest<Req: RequestProtocol>(_ request: Req, url: URL) -> URLRequest? {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.timeoutInterval = connectionTimeout
        
        if let parameters = request.bodyParameters {
            guard JSONSerialization.isValidJSONObject(parameters) else { return nil }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let headers: [String: String] = request.headers ?? [:]
        headers.forEach({ (k, v) in
            urlRequest.addValue(v, forHTTPHeaderField: k)
        })
        
        return urlRequest
    }
    
    fileprivate func computeURL<Req: RequestProtocol>(_ request: Req) -> URL? {
        
        var urlComponents = URLComponents(string: request.endpoint)
        urlComponents?.queryItems = request.requestParameters?.map { return URLQueryItem(name: $0.key, value: "\($0.value)")}
        return urlComponents?.url
    }
    
    fileprivate func connectionLog<Req: RequestProtocol>(_ request: Req) {
        print("\(String(describing: type(of: request.urlSession))) connection: Request \(request.httpMethod.rawValue)")
        print (request.endpoint)
    }
}
