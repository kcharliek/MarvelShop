//
//  MockSearchCharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


#if ON_SAMPLE

final class MockSearchCharacterDataStore: SearchCharacterDataStoreProtocol {

    func searchCharacter(query: String, page: Int) -> AnyPublisher<SearchCharacterResult, Error> {
        let characters = (0..<Constant.pageSize)
            .map { _ in makeMockCharacter(query: query) }

        return Just<SearchCharacterResult>((items: characters, hasNext: true))
            .mapError()
            .eraseToAnyPublisher()
    }

    private func makeMockCharacter(query: String) -> MCharacter {
        let name = "\(query)" + (0..<3)
            .map { _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()! }
            .map(String.init)
            .joined()
        let description = (0..<Int.random(in: 0..<10)).reduce("") { (text, _) in text + "MOCK DESCRIPTION " }

        return .init(
            id: UUID().hashValue,
            name: name,
            description: description,
            thumbnailImageURLString: ""
        )
    }

}

#endif
