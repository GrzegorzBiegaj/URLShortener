//
//  ReadShortURLInterpreterTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class ReadShortURLInterpreterTests: XCTestCase {

    func testReadInterpreterValidData() {
        
        var data: Data?
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let successStatusCode = 200
        
        let shortURLs = [ShortURL(id: 123, url: "testUrl1", shortUrl: "shortUrl1", creationDate: Date()),
                         ShortURL(id: 234, url: "testUrl2", shortUrl: "shortUrl2", creationDate: Date()),
                         ShortURL(id: 888, url: "testUrl3", shortUrl: "shortUrl3", creationDate: Date())]
        
        do {
            data = try JSONEncoder().encode(shortURLs)
        }
        catch {
            XCTFail()
        }
        
        let readShortURLInterpreter = ReadShortURLInterpreter()
        let resp = readShortURLInterpreter.interpret(data: data, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(let data):
            XCTAssertEqual(data, shortURLs)
        case .error(_):
            XCTFail()
        }
    }
    
    func testReadInterpreterInvalidResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let successStatusCode = 400
        let readShortURLInterpreter = ReadShortURLInterpreter()
        let resp = readShortURLInterpreter.interpret(data: nil, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.invalidResponseError)
        }
    }
    
    func testReadInterpreterError() {
        
        let response = HTTPURLResponse()
        let error = ResponseError.wrongUrlScheme
        let successStatusCode = 400
        
        let readShortURLInterpreter = ReadShortURLInterpreter()
        let resp = readShortURLInterpreter.interpret(data: nil, response: response, error: error, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.wrongUrlScheme)
        }
    }
}
