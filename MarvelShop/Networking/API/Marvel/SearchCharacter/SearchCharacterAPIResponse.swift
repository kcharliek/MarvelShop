//
//  SearchCharacterAPIResponse.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


struct SearchCharacterAPIResponse: Decodable {

    let code: Int
    let data: ResultData?

    struct ResultData: Decodable {

        let offset, limit, total, count: Int
        let results: [_Character]

        struct _Character: Decodable {

            let id: Int
            let name, description: String
            let thumbnail: Thumbnail

        }

        struct Thumbnail: Decodable {

            let path: String

        }

    }

}
