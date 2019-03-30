//
//  WriteShortURLRequestTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class WriteShortURLRequestTests: XCTestCase {

    func testWriteRequest() {
        
        let loversRequest = WriteShortURLRequest(url: "http://testUrl.ch")
        
        XCTAssertEqual(loversRequest.successStatusCode, 201)
        XCTAssertEqual(loversRequest.httpMethod, .post)
        XCTAssertEqual(loversRequest.endpoint, "http://url-shortener.com/api/short")
        XCTAssertEqual(loversRequest.headers?["Content-Type"], "application/json")
        XCTAssertEqual(loversRequest.bodyParameters?["url"] as! String, loversRequest.url)
        XCTAssertNil(loversRequest.requestParameters)
        XCTAssertNotNil(loversRequest.interpreter)
    }

}
