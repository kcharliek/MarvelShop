//
//  APIRequest.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


protocol APIRequest {

    associatedtype APIResponse: Decodable

    var method: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var paramters: [String: Any] { get }
    var headers: [String: String] { get }
    var commonParamters: [String: Any] { get }
    var commonHeaders: [String: String] { get }

}

extension APIRequest {
    
    var paramters: [String: Any] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }

    var commonParamters: [String: Any] {
        [:]
    }

    var commonHeaders: [String: String] {
        [:]
    }

}
