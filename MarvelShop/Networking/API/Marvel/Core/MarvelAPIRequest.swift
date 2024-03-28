//
//  MarvelAPIRequest.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


protocol MarvelAPIRequest: APIRequest { }

extension MarvelAPIRequest {

    var baseURLString: String {
        "https://gateway.marvel.com:443"
    }

    var commonParamters: [String: Any] {
        let ts = Date().timeIntervalSince1970

        return [
            "ts": ts,
            "apikey" : Secret.API_KEY_PUBLIC,
            "hash": ("\(ts)" + Secret.API_KEY_PRIVATE + Secret.API_KEY_PUBLIC).MD5()
        ]
    }

    var commonHeaders: [String: Any] {
        ["Content-Type": "application/json"]
    }

}
