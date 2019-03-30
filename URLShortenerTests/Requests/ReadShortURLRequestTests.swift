//
//  ReadShortURLRequestTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class ReadShortURLRequestTests: XCTestCase {

    func testReadRequest() {

        let loversRequest = ReadShortURLRequest()
        
        XCTAssertEqual(loversRequest.successStatusCode, 200)
        XCTAssertEqual(loversRequest.httpMethod, .get)
        XCTAssertEqual(loversRequest.endpoint, "http://url-shortener.com/api/short")
        XCTAssertEqual(loversRequest.headers?["Content-Type"], "application/json")
        XCTAssertNil(loversRequest.bodyParameters)
        XCTAssertNil(loversRequest.requestParameters)
        XCTAssertNotNil(loversRequest.interpreter)
    }

}
