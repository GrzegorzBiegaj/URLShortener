//
//  MockURLHandlerTests.swift
//  URLShortenerTests
//
//  Created by Grzesiek on 31/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import URLShortener

class MockURLHandlerTests: XCTestCase {

    var mockURLHandler: MockURLHandler = {
       return MockURLHandler()
    }()
    
    let postUrl1 = "http://test.ch"
    let postUrl2 = "http://test2.ch"
    
    func testGetPostDeleteSuccess() {
        // ShortURL array empty
        getEmptySuccess()
        
        // Post one item
        postItem(url: postUrl1)
        
        // Get to check posted item
        getOneEntrySuccess(url: postUrl1)
        
        // Post second item
        postItem(url: postUrl2)
        
        // Get to check posted items
        getTwoEntriesSuccess(url1: postUrl1, url2: postUrl2)
        
        // Post item without URL key
        postItemWithoutUrl()
        
        // Post item with wrong URL key
        postItemWrongUrlKey(url: "http://test100.ch")
        
        // Post item with wrong URL scheme
        postItemWrongUrlScheme(url: "httpWrong://test101.ch")
        
        // Post existing item 1
        postSameItem(url: postUrl1)
        
        // Get to check posted 2 items
        getTwoEntriesSuccess(url1: postUrl1, url2: postUrl2)
        
        // Delete second item
        deleteItem(index: 1)
        
        // Get to check items after delete
        getOneEntrySuccess(url: postUrl2)
        
        // Delete item with wrong id
        deleteWrongIdItem()
        
        // Get to check items after unsuccessful delete
        getOneEntrySuccess(url: postUrl2)
    }
    
    func getEmptySuccess() {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            let resp = try? JSONDecoder().decode([ShortURL].self, from: data!)
            XCTAssertEqual(resp?.count, 0)
            XCTAssertEqual(resp, [])
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 200)
        }
    }
    
    func postItem(url: String) {

        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200, httpMetodRequest: .post, body: ["url" : url])
        
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 201)
            let resp = try? JSONDecoder().decode(ShortURL.self, from: data!)
            XCTAssertEqual(resp?.url, url)
            XCTAssertNotNil(resp?.id)
            XCTAssertNotNil(resp?.shortUrl)
            XCTAssertNotNil(resp?.creationDate)
        }
    }
    
    func getOneEntrySuccess(url: String) {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            let resp = try? JSONDecoder().decode([ShortURL].self, from: data!)
            XCTAssertEqual(resp?.count, 1)
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 200)
            XCTAssertEqual(resp?[0].url, url)
            XCTAssertNotNil(resp?[0].id)
            XCTAssertNotNil(resp?[0].shortUrl)
            XCTAssertNotNil(resp?[0].creationDate)
        }
    }
    
    func getTwoEntriesSuccess(url1: String, url2: String) {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            let resp = try? JSONDecoder().decode([ShortURL].self, from: data!)
            XCTAssertEqual(resp?.count, 2)
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 200)
            XCTAssertEqual(resp?[0].url, url2)
            XCTAssertNotNil(resp?[0].id)
            XCTAssertNotNil(resp?[0].shortUrl)
            XCTAssertNotNil(resp?[0].creationDate)
            XCTAssertEqual(resp?[1].url, url1)
            XCTAssertNotNil(resp?[1].id)
            XCTAssertNotNil(resp?[1].shortUrl)
            XCTAssertNotNil(resp?[1].creationDate)
        }
    }

    func postItemWithoutUrl() {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200, httpMetodRequest: .post)
        
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertEqual(error as! ResponseError, ResponseError.noUrl)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
            XCTAssertNil(data)
            XCTAssertNotNil(response)
        }
    }
    
    func postItemWrongUrlKey(url: String) {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200, httpMetodRequest: .post, body: ["wrong url key" : url])
        
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertEqual(error as! ResponseError, ResponseError.wrongUrlKey)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
            XCTAssertNil(data)
            XCTAssertNotNil(response)
        }
    }
    
    func postItemWrongUrlScheme(url: String) {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200, httpMetodRequest: .post, body: ["url" : url])
        
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertEqual(error as! ResponseError, ResponseError.wrongUrlScheme)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
            XCTAssertNil(data)
            XCTAssertNotNil(response)
        }
    }
    
    func postSameItem(url: String) {
        
        let request = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200, httpMetodRequest: .post, body: ["url" : url])
        
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertEqual(error as! ResponseError, ResponseError.urlAlreadyExists)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
            XCTAssertNil(data)
            XCTAssertNotNil(response)
        }
    }
    
    func deleteItem(index: Int) {
        // get items to obtain entry id
        let getRequest = URLRequestMock(url: "http://url-shortener.com/api/short", statusCode: 200)
        let getUrlReqest = setupURLRequest(getRequest, url: URL(string: getRequest.url)!)!
        var shortUrl: ShortURL?
        mockURLHandler.handleData(request: getUrlReqest) { (data, response, error) in
            let resp = try? JSONDecoder().decode([ShortURL].self, from: data!)
            shortUrl = resp![index]
        }
        
        // delete item
        let request = URLRequestMock(url: "http://url-shortener.com/api/short/\(String(shortUrl!.id))", statusCode: 200, httpMetodRequest: .delete)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 200)
            let resp = try? JSONDecoder().decode(ShortURL.self, from: data!)
            XCTAssertEqual(resp?.url, shortUrl!.url)
            XCTAssertEqual(resp?.id, shortUrl!.id)
            XCTAssertEqual(resp?.shortUrl, shortUrl!.shortUrl)
            XCTAssertEqual(resp?.creationDate, shortUrl!.creationDate)
        }
    }
    
    func deleteWrongIdItem() {
        let request = URLRequestMock(url: "http://url-shortener.com/api/short/1000", statusCode: 200, httpMetodRequest: .delete)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        mockURLHandler.handleData(request: urlReqest) { (data, response, error) in
            XCTAssertEqual(error as! ResponseError, ResponseError.idNotFound)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
            XCTAssertNil(data)
            XCTAssertNotNil(response)
        }
    }
    
    func testGetWrongEndpoint() {

        let request = URLRequestMock(url: "test", statusCode: 200)
        let urlReqest = setupURLRequest(request, url: URL(string: request.url)!)!
        MockURLHandler().handleData(request: urlReqest) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNil(error)
            let res = response as! HTTPURLResponse
            XCTAssertEqual(res.statusCode, 400)
        }
    }

    func setupURLRequest<Req: RequestProtocol>(_ request: Req, url: URL) -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        if let parameters = request.bodyParameters {
            guard JSONSerialization.isValidJSONObject(parameters) else { return nil }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        return urlRequest
    }

}
