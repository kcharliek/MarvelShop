//
//  SearchCharacterAPIRequest.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


struct SearchCharacterAPIRequest {

    private let query: String?

    init(query: String? = nil) {
        self.query = query
    }

}

extension SearchCharacterAPIRequest: MarvelAPIRequest {

    typealias APIResponse = SearchCharacterAPIResponse

    var path: String {
        "/v1/public/characters"
    }

    var method: HTTPMethod {
        .get
    }

    var paramters: [String : Any] {
        if let _query = query, _query.isEmpty == false {
            return ["nameStartsWith": _query]
        } else {
            return [:]
        }
    }

}
