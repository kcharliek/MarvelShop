//
//  TMockSearchCharacterDataStore.swift
//  MarvelShopTests
//
//  Created by Charlie
//

import Foundation
import Combine
@testable import MarvelShop


final class TMockSearchCharacterDataStore: SearchCharacterDataStoreProtocol {

    // MARK: - Properties

    var lastRequestQuery: String?
    var lastRequestPage: Int?

    // MARK: - Methods

    func searchCharacter(query: String, page: Int) -> AnyPublisher<MarvelShop.SearchCharacterResult, Error> {
        lastRequestQuery = query
        lastRequestPage = page

        let name = query.isEmpty ? "empty" : query

        let character = MCharacter.init(
            id: UUID().hashValue,
            name: name,
            description: "description",
            thumbnailImageURLString: ""
        )

        return Just<MarvelShop.SearchCharacterResult>.init((items: [character], hasNext: true))
            .mapError()
            .eraseToAnyPublisher()
    }

    func reset() {
        lastRequestQuery = nil
        lastRequestPage = nil
    }

}
