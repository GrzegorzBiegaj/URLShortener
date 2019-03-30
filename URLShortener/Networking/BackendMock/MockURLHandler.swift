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
    
    fileprivate static let endpointURL = URL(string: "http://url-shortener.com/api/short")
    fileprivate static let outputPrefixURL = URL(string: "https://url-shortener.com")!
    fileprivate static let schemes = ["http", "https"]
    
    fileprivate let storage = InMemoryStorage.sharedInstance
    
    // MARK: Public interface
    
    func handleData(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var statusCode = 400
        var error: Error?
        var data: Data?
        
        guard let url = request.url else { completionHandler(nil, nil, nil); return }
        
        switch request.httpMethod {
        case HTTPMethod.get.rawValue:
            statusCode = validateEndpoint(request: request) ? 200 : 400
            if statusCode == 200 {
                data = restore()
            }
        case HTTPMethod.post.rawValue:
            handlePost(request: request) { retData, retError, retStatusCode in
                data = retData
                error = retError
                statusCode = retStatusCode
            }
        case HTTPMethod.delete.rawValue:
            handleDelete(request: request) { retData, retError, retStatusCode in
                data = retData
                error = retError
                statusCode = retStatusCode
            }
        default:
            error = NSError(domain: "Invalid request", code: 150, userInfo: nil)
            break
        }
        
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields)
        
        completionHandler(data, response, error)
    }
    
    // MARK: Handlers
    
    fileprivate func handlePost(request: URLRequest, handler: (Data?, Error?, Int) -> Void) {
        var error: Error?
        var data: Data?
        var statusCode = 400
        
        if !validateEndpoint(request: request) { handler(data, error, statusCode); return }

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
            statusCode = 201
        default:
            error = NSError(domain: "Unknown error", code: 199, userInfo: nil)
        }
        handler(data, error, statusCode)
    }
    
    fileprivate func handleDelete(request: URLRequest, handler: (Data?, Error?, Int) -> Void) {
        var error: Error?
        var data: Data?
        var statusCode = 400

        if !validateDeleteEndpoint(request: request) { handler(data, error, statusCode); return }
        
        if let stringId = request.url?.lastPathComponent, let identifier = Int(stringId) {
            switch validateId(id: identifier) {
            case .idNotFound:
                error = NSError(domain: "URL not found", code: 110, userInfo: nil)
            case .success(let identifier):
                data = delete(id: identifier)
                statusCode = 200
            default:
                error = NSError(domain: "Unknown error", code: 199, userInfo: nil)
            }
        } else {
            error = NSError(domain: "Unknown error", code: 199, userInfo: nil)
        }
        handler(data, error, statusCode)
    }
    
    // MARK: Private data validation
    
    fileprivate enum ValidationResult<T> {
        case success(T)
        case wrongUrlKey
        case noUrl
        case wrongUrlScheme
        case urlAlreadyExists
        case idNotFound
    }
    
    fileprivate func validateUrl(data: Data?) -> ValidationResult<String> {
        guard let data = data else { return .noUrl }
        guard let response = try? JSONDecoder().decode(WriteData.self, from: data) else { return .wrongUrlKey }
        guard let url = URL(string: response.url) else { return .wrongUrlScheme }
        let filteredSchemes = MockURLHandler.schemes.filter { $0 == url.scheme }
        guard !filteredSchemes.isEmpty else { return .wrongUrlScheme }
        guard let items = getShortURLs?.items else { return .success(response.url) }
        return items.filter { $0.url == response.url }.isEmpty ? .success(response.url) : .urlAlreadyExists
    }
    
    fileprivate func validateId(id: Int) -> ValidationResult<Int> {
        let localShortURLs = getShortURLs ?? MockStorageShortURLs(items: [])
        let item = localShortURLs.items.first { $0.id == id }
        if let item = item {
            return .success(item.id)
        }
        return .idNotFound
    }
    
    fileprivate func validateEndpoint(request: URLRequest) -> Bool {
        if let url = request.url, url.pathComponents == MockURLHandler.endpointURL?.pathComponents {
            return true
        }
        return false
    }

    fileprivate func validateDeleteEndpoint(request: URLRequest) -> Bool {
        if let url = request.url, url.deletingLastPathComponent().pathComponents ==  MockURLHandler.endpointURL?.pathComponents {
            return true
        }
        return false
    }
    
    // MARK: Private store / restore / delete
    
    fileprivate struct WriteData: Decodable {
        let url: String
    }
    
    fileprivate func store(url: String) -> Data? {
        let shortUrlString = makeShortUrl(url: url)
        let shortURL = ShortURL(id: makeId(), url: url, shortUrl: shortUrlString, creationDate: Date())
        let localShortURLs = getShortURLs ?? MockStorageShortURLs(items: [])
        storage.store(MockStorageShortURLs(items: localShortURLs.items + [shortURL]))
        guard let resultData = try? JSONEncoder().encode(shortURL) else { return nil }
        return resultData
    }
    
    fileprivate func restore() -> Data? {
        guard let data = try? JSONEncoder().encode(getSortedShortURLs) else { return nil }
        return data
    }
    
    fileprivate func delete(id: Int) -> Data? {
        let localShortURLs = getShortURLs ?? MockStorageShortURLs(items: [])
        let shortURLToDelete = localShortURLs.items.first { $0.id == id }
        let newShortURL = localShortURLs.items.filter { $0.id != id }
        storage.store(MockStorageShortURLs(items: newShortURL))
        guard let resultData = try? JSONEncoder().encode(shortURLToDelete) else { return nil }
        return resultData
    }
    
    fileprivate var getShortURLs: MockStorageShortURLs? {
        return storage.tryRestore()
    }
    
    fileprivate var getSortedShortURLs: [ShortURL] {
        guard let items = getShortURLs?.items else { return [] }
        let sorted = items.sorted(by: { $0.creationDate > $1.creationDate })
        return sorted.map { ShortURL(id: $0.id, url: $0.url, shortUrl: MockURLHandler.outputPrefixURL.appendingPathComponent($0.shortUrl).absoluteString, creationDate: $0.creationDate) }
    }
    
    // MARK: Private generate keys
    
    fileprivate func makeId() -> Int {
        var identifier = UUID().hashValue
        let localShortURLs = getShortURLs ?? MockStorageShortURLs(items: [])
        let duplicate = localShortURLs.items.first { $0.id == identifier }
        if let _ = duplicate {
            identifier = makeId()
        }
        return identifier
    }
 
    fileprivate func makeShortUrl(url: String) -> String {
        let base: UInt32 = 1000000000
        var short = String(UInt64(arc4random_uniform(base)))
        let localShortURLs = getShortURLs ?? MockStorageShortURLs(items: [])
        let duplicate = localShortURLs.items.first { $0.shortUrl == short }
        if let _ = duplicate {
            short = makeShortUrl(url: url)
        }
        return short
    }
}
