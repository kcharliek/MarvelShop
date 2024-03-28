//
//  CharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


protocol CharacterDataStoreProtocol {

    func searchCharacter(query: String, page: Int) -> AnyPublisher<[MCharacter], Error>

}

enum CharacterDataStoreError: Error {

    case unknown

}

final class CharacterDataStore: CharacterDataStoreProtocol {

    private let size: Int = 30

    func searchCharacter(query: String, page: Int) -> AnyPublisher<[MCharacter], Error> {
        let request = SearchCharacterAPIRequest(query: query, page: page, size: size)

        return API.request(request)
            .tryMap {
                if $0.code == 200, let data = $0.data {
                    return data.results.map { MCharacter.init(response: $0) }
                } else {
                    throw CharacterDataStoreError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

}

private extension MCharacter {

    init(response: SearchCharacterAPIResponse.ResultData._Character) {
        self.id = response.id
        self.name = response.name
        self.description = response.description
        self.thumbnailImageURLString = response.thumbnail.path + "." + response.thumbnail.ext
    }

}
