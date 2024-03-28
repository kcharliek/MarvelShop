//
//  MURLSessionTests.swift
//  MarvelShopTests
//
//  Created by Charlie
//

import XCTest
@testable import MarvelShop


final class MURLSessionTests: XCTestCase {

    func test_get으로_URLRequest생성시_값정상여부() {
        // given
        let session = MURLSession()
        let baseURLString = "www.base.com"
        let methods = HTTPMethod.get
        let paramters = ["param1": 1, "param2" : 2]
        let headers = ["header1": "1"]

        // when
        let urlRequest = try? session.makeURLRequest(urlString: baseURLString, method: methods, parameters: paramters, headers: headers)
        let urlString = urlRequest?.url?.absoluteString

        // then
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlString)
        XCTAssertTrue(urlString!.starts(with: baseURLString))
        XCTAssertTrue(urlString!.contains("param1=1"))
        XCTAssertTrue(urlString!.contains("param2=2"))
        XCTAssertNil(urlRequest!.httpBody)
        XCTAssertTrue(urlRequest!.allHTTPHeaderFields!["header1"] == "1")
    }

    func test_post로_URLRequest생성시_값정상여부() {
        // given
        let session = MURLSession()
        let baseURLString = "www.base.com"
        let methods = HTTPMethod.post
        let paramters = ["param1": 1, "param2" : 2]
        let headers = ["header1": "1"]

        // when
        let urlRequest = try? session.makeURLRequest(urlString: baseURLString, method: methods, parameters: paramters, headers: headers)
        let urlString = urlRequest?.url?.absoluteString

        // then
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlString)
        XCTAssertTrue(urlString!.starts(with: baseURLString))
        XCTAssertFalse(urlString!.contains("param1=1"))
        XCTAssertFalse(urlString!.contains("param2=2"))
        XCTAssertTrue(urlRequest!.allHTTPHeaderFields!["header1"] == "1")

        if let httpBody = urlRequest!.httpBody,
           let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any]
        {
            XCTAssertTrue(json["param1"] as? Int == 1)
            XCTAssertTrue(json["param2"] as? Int == 2)
        } else {
            XCTFail()
        }
    }

}
