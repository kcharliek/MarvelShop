//
//  SearchCharacterAPIRequest.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


struct SearchCharacterAPIRequest {

    private let query: String?
    private let page: Int
    private let size: Int

    init(query: String? = nil, page: Int, size: Int) {
        self.query = query
        self.page = page
        self.size = size
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
        var params: [String: Any] = [
            "limit": size,
            "offset": page * size
        ]

        if let _query = query, _query.isEmpty == false {
            params["nameStartsWith"] = _query
        }

        return params
    }

}
