//
//  SearchCharacterDataStoreProtocol.swift
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

