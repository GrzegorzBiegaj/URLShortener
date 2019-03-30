//
//  ShortURLTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class ShortURLTests: XCTestCase {

    func testEquatable() {
        
        let testDate = Date()
        let shortURL1 = ShortURL(id: 123, url: "TestUrl1", shortUrl: "ShortUrl1", creationDate: testDate)
        let shortURL2 = ShortURL(id: 123, url: "TestUrl1", shortUrl: "ShortUrl1", creationDate: testDate)
        
        let shortURL1_1 = ShortURL(id: 1234, url: "TestUrl1", shortUrl: "ShortUrl1", creationDate: testDate)
        let shortURL1_2 = ShortURL(id: 123, url: "TestUrlX", shortUrl: "ShortUrl1", creationDate: testDate)
        let shortURL1_3 = ShortURL(id: 123, url: "TestUrl1", shortUrl: "ShortUrlX", creationDate: testDate)
        let shortURL1_4 = ShortURL(id: 123, url: "TestUrl1", shortUrl: "ShortUrl1", creationDate: Date(timeIntervalSince1970: 1234))
        
        XCTAssertEqual(shortURL1, shortURL2)
        XCTAssertNotEqual(shortURL1, shortURL1_1)
        XCTAssertNotEqual(shortURL1, shortURL1_2)
        XCTAssertNotEqual(shortURL1, shortURL1_3)
        XCTAssertNotEqual(shortURL1, shortURL1_4)
    }

}
