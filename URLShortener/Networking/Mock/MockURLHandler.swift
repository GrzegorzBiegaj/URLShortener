//
//  MockURLHandler.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class MockURLHandler {
    
    // MARK: Configuration
    
    fileprivate static let prefix = "https://url-shortener.com/"
    fileprivate static let schemes = ["http", "https"]
    
    fileprivate let storage = InMemoryStorage.sharedInstance
    
    // MARK: Public interface
    
    func handleData(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var statusCode = 200
        var error: Error?
        var data: Data?
        
        guard let url = request.url else { completionHandler(nil, nil, nil); return }
        
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
        
        completionHandler(data, response, error)
    }
    
    // MARK: Private data validation
    
    fileprivate enum ValidationResult {
        case success(String)
        case wrongUrlKey
        case noUrl
        case wrongUrlScheme
        case urlAlreadyExists
    }
    
    fileprivate func validateUrl(data: Data?) -> ValidationResult {
        guard let data = data else { return .noUrl }
        guard let response = try? JSONDecoder().decode(WriteData.self, from: data) else { return .wrongUrlKey }
        guard let url = URL(string: response.url) else { return .wrongUrlScheme }
        let filteredSchemes = MockURLHandler.schemes.filter { $0 == url.scheme }
        guard !filteredSchemes.isEmpty else { return .wrongUrlScheme }
        guard let items = getShorteners?.items else { return .success(response.url) }
        return items.filter { $0.url == response.url }.isEmpty ? .success(response.url) : .urlAlreadyExists
    }
    
    // MARK: Private store / restore
    
    fileprivate struct WriteData: Decodable {
        let url: String
    }
    
    fileprivate func store(url: String) -> Data? {
        let shortUrl = makeShortUrl(url: url)
        let shortener = Shortener(id: makeId(), url: url, shortUrl: shortUrl, creationDate: Date())
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
    
    // MARK: Private generate keys
    
    fileprivate func makeId() -> Int {
        var identifier = UUID().hashValue
        let localShorteners = getShorteners ?? MockStorageShorteners(items: [])
        let duplicate = localShorteners.items.first { $0.id == identifier }
        if let _ = duplicate {
            identifier = makeId()
        }
        return identifier
    }
 
    fileprivate func makeShortUrl(url: String) -> String {
        let base: UInt32 = 1000000000
        var short = String(UInt64(arc4random_uniform(base)))
        let localShorteners = getShorteners ?? MockStorageShorteners(items: [])
        let duplicate = localShorteners.items.first { $0.shortUrl == short }
        if let _ = duplicate {
            short = makeShortUrl(url: url)
        }
        return short
    }
}
