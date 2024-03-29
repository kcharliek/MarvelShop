//
//  SearchCharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


typealias SearchCharacterResult = (items: [MCharacter], hasNext: Bool)

protocol SearchCharacterDataStoreProtocol {

    func searchCharacter(query: String, page: Int) -> AnyPublisher<SearchCharacterResult, Error>

}

enum SearchCharacterDataStoreError: Error {

    case unknown

}

final class SearchCharacterDataStore: SearchCharacterDataStoreProtocol {

    func searchCharacter(query: String, page: Int) -> AnyPublisher<SearchCharacterResult, Error> {
        let request = SearchCharacterAPIRequest(query: query, page: page, size: Constant.pageSize)

        return API.request(request)
            .tryMap {
                if $0.code == 200, let data = $0.data {
                    let hasNext = data.offset + data.count < data.total
                    return (items: data.results.map { MCharacter.init(response: $0) }, hasNext: hasNext)
                } else {
                    throw SearchCharacterDataStoreError.unknown
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
