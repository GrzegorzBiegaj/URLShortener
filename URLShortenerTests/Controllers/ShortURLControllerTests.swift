//
//  ShortURLControllerTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class ShortURLControllerTests: XCTestCase {

    func testGetPositiveResponse() {

        var data: Data?
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let shortURLs = [ShortURL(id: 123, url: "testUrl1", shortUrl: "shortUrl1", creationDate: Date()),
                         ShortURL(id: 234, url: "testUrl2", shortUrl: "shortUrl2", creationDate: Date()),
                         ShortURL(id: 888, url: "testUrl3", shortUrl: "shortUrl3", creationDate: Date())]
        do {
            data = try JSONEncoder().encode(shortURLs)
        }
        catch {
            XCTFail()
        }

        let mockNetworking = NetworkingMock(data: data, error: nil, response: response)
        let shortURLController = ShortURLController(connection: mockNetworking)

        shortURLController.getShortURLData { (response) in
            switch response {
            case .success(let responseData):
                XCTAssertEqual(responseData, shortURLs)
            case .failure(_):
                XCTFail()
            }
        }
    }

    func testGetNegativeResponse() {

        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: nil, response: response))
        shortURLController.getShortURLData { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testGetNegativeError() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: ResponseError.decodeError, response: response))
        shortURLController.getShortURLData { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.decodeError)
            }
        }
    }
    
    func testStorePositiveResponse() {
        
        var data: Data?
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        let shortURL = ShortURL(id: 123, url: "http://test.demo.ch", shortUrl: "shortUrl1", creationDate: Date())
        do {
            data = try JSONEncoder().encode(shortURL)
        }
        catch {
            XCTFail()
        }

        let mockNetworking = NetworkingMock(data: data, error: nil, response: response)
        let shortURLController = ShortURLController(connection: mockNetworking)
        
        shortURLController.storeShortURLData(url: "") { (response) in
            switch response {
            case .success(let responseData):
                XCTAssertEqual(responseData, shortURL)
            case .failure(_):
                XCTFail()
            }
        }
    }

    func testStoreNegativeResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: nil, response: response))
        shortURLController.storeShortURLData(url: "") { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testStoreNegativeError() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: ResponseError.urlAlreadyExists, response: response))
        shortURLController.storeShortURLData(url: "") { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.urlAlreadyExists)
            }
        }
    }
    
    func testDeletePositiveResponse() {
        
        var data: Data?
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let shortURL = ShortURL(id: 123, url: "http://test.demo.ch", shortUrl: "shortUrl1", creationDate: Date())
        do {
            data = try JSONEncoder().encode(shortURL)
        }
        catch {
            XCTFail()
        }
        
        let mockNetworking = NetworkingMock(data: data, error: nil, response: response)
        let shortURLController = ShortURLController(connection: mockNetworking)
        
        shortURLController.deleteShortURLData(id: 0) { (response) in
            switch response {
            case .success(let responseData):
                XCTAssertEqual(responseData, shortURL)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testDeleteNegativeResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: nil, response: response))
        shortURLController.deleteShortURLData(id: 0) { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testDeleteNegativeError() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let shortURLController = ShortURLController(connection: NetworkingMock(data: nil, error: ResponseError.urlAlreadyExists, response: response))
        shortURLController.deleteShortURLData(id: 0) { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.urlAlreadyExists)
            }
        }
    }
}
