//
//  DeleteShortURLRequestTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class DeleteShortURLRequestTests: XCTestCase {

    func testDeleteRequest() {
        
        let id = 123
        let loversRequest = DeleteShortURLRequest(id: id)
        
        XCTAssertEqual(loversRequest.successStatusCode, 200)
        XCTAssertEqual(loversRequest.httpMethod, .delete)
        XCTAssertEqual(loversRequest.endpoint, "http://url-shortener.com/api/short/" + "\(String(id))")
        XCTAssertEqual(loversRequest.headers?["Content-Type"], "application/json")
        XCTAssertNil(loversRequest.bodyParameters)
        XCTAssertNil(loversRequest.requestParameters)
        XCTAssertNotNil(loversRequest.interpreter)
    }

}
