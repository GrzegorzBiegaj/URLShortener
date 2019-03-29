//
//  MockURLHandler.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class MockURLHandler {
    
    static let prefix = "https://url-shortener.com/"
    
    struct DataResult {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    fileprivate let storage = InMemoryStorage.sharedInstance
    
    func handleData(request: URLRequest) -> DataResult {
        var statusCode = 200
        var error: Error?
        var data: Data?
        
        guard let url = request.url else { return DataResult(data: nil, response: nil, error: nil) }
        
        switch request.httpMethod {
        case HTTPMethod.get.rawValue:
            data = restore()
        case HTTPMethod.post.rawValue:
            switch validateUrl(data: request.httpBody) {
            case .noUrl:
                error = NSError(domain: "URL not found", code: 100, userInfo: nil)
            case .wrongUrlKey:
                error = NSError(domain: "Wrong URL key", code: 101, userInfo: nil)
            case .wrongUrlScheme:
                error = NSError(domain: "Wrong URL scheme, only http and https are supported", code: 102, userInfo: nil)
            case .urlAlreadyExists:
                error = NSError(domain: "URL already exists", code: 103, userInfo: nil)
            case .success(let url):
                data = store(url: url)
            }
        case HTTPMethod.delete.rawValue:
            break
        default:
            statusCode = 400
            error = NSError(domain: "Invalid request", code: 150, userInfo: nil)
            break
        }
        
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields)
        
        return DataResult(data: data, response: response,   error: error)
    }
    
    // MARK - Private data validation
    
    enum ValidationResult {
        case success(String)
        case wrongUrlKey
        case noUrl
        case wrongUrlScheme
        case urlAlreadyExists
    }
    
    fileprivate func validateUrl(data: Data?) -> ValidationResult {
        guard let data = data else { return .noUrl }
        guard let response = try? JSONDecoder().decode(WriteData.self, from: data) else { return .wrongUrlKey }
        guard let url = URL(string: response.url), url.scheme == "http" || url.scheme == "https" else { return .wrongUrlScheme }
        guard let items = getShorteners?.items else { return .success(response.url) }
        return items.filter { $0.url == response.url }.isEmpty ? .success(response.url) : .urlAlreadyExists
    }
    
    // MARK - Private store / restore
    
    fileprivate struct WriteData: Decodable {
        let url: String
    }
    
    fileprivate func store(url: String) -> Data? {
        let shortUrl = makeShortUrl(url: url)
        let shortener = Shortener(id: makeId, url: url, shortUrl: shortUrl, creationDate: Date())
        let localShorteners = getShorteners ?? MockStorageShorteners(items: [])
        storage.store(MockStorageShorteners(items: localShorteners.items + [shortener]))
        guard let resultData = try? JSONEncoder().encode(shortener) else { return nil }
        return resultData
    }
    
    fileprivate func restore() -> Data? {
        guard let data = try? JSONEncoder().encode(getSortedShorteners) else { return nil }
        return data
    }
    
    fileprivate var getShorteners: MockStorageShorteners? {
        return storage.tryRestore()
    }
    
    fileprivate var getSortedShorteners: [Shortener] {
        guard let items = getShorteners?.items else { return [] }
        let sorted = items.sorted(by: { $0.creationDate > $1.creationDate })
        return sorted.map { Shortener(id: $0.id, url: $0.url, shortUrl: MockURLHandler.prefix + $0.shortUrl, creationDate: $0.creationDate) }
    }
    
    // MARK - Private generate keys
    
    var makeId: Int {
        return UUID().hashValue
    }
    
    fileprivate func makeShortUrl(url: String) -> String {
        let unicodeScalars = url.unicodeScalars.map { Int($0.value) }
        let value = unicodeScalars.reduce(0, +)
        return String(value)
    }
}
