//
//  WriteShortURLInterpreterTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class WriteShortURLInterpreterTests: XCTestCase {

    func testWriteInterpreterValidData() {
        
        var data: Data?
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let successStatusCode = 200
        
        let shortURL = ShortURL(id: 123, url: "testUrl1", shortUrl: "shortUrl1", creationDate: Date())
        
        do {
            data = try JSONEncoder().encode(shortURL)
        }
        catch {
            XCTFail()
        }
        
        let writeShortURLInterpreter = WriteShortURLInterpreter()
        let resp = writeShortURLInterpreter.interpret(data: data, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(let data):
            XCTAssertEqual(data, shortURL)
        case .error(_):
            XCTFail()
        }
    }
    
    func testWriteInterpreterInvalidResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let successStatusCode = 400
        let writeShortURLInterpreter = WriteShortURLInterpreter()
        let resp = writeShortURLInterpreter.interpret(data: nil, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.invalidResponseError)
        }
    }
    
    func testWriteInterpreterError() {
        
        let response = HTTPURLResponse()
        let error = ResponseError.wrongUrlScheme
        let successStatusCode = 400
        
        let writeShortURLInterpreter = WriteShortURLInterpreter()
        let resp = writeShortURLInterpreter.interpret(data: nil, response: response, error: error, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.wrongUrlScheme)
        }
    }
}
