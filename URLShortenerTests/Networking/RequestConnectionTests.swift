//
//  RequestConnectionTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class RequestConnectionTests: XCTestCase {

    func testperformRequestSuccess() {
        
        var data: Data?
        let shortURLs = [ShortURL(id: 123, url: "testUrl1", shortUrl: "shortUrl1", creationDate: Date()),
                         ShortURL(id: 234, url: "testUrl2", shortUrl: "shortUrl2", creationDate: Date()),
                         ShortURL(id: 888, url: "testUrl3", shortUrl: "shortUrl3", creationDate: Date())]
        do {
            data = try JSONEncoder().encode(shortURLs)
        }
        catch {
            XCTFail()
        }
        
        let request = URLRequestMock(url: "test", statusCode: 200, error: nil, data: data)
        let connection = RequestConnection()
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(let response):
                XCTAssertEqual(response, shortURLs)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testperformRequestFail() {
        
        let request = URLRequestMock(url: "test", statusCode: 123, error: nil, data: nil)
        let connection = RequestConnection()
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testperformRequestError() {

        let error = ResponseError.wrongUrlKey
        let request = URLRequestMock(url: "test", statusCode: 123, error: error, data: nil)
        let connection = RequestConnection()
        connection.performRequest(request: request) { (response) in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.wrongUrlKey)
            }
        }
    }

}
