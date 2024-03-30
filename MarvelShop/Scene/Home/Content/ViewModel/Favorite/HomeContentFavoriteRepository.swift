//
//  HomeContentFavoriteRepository.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


protocol HomeContentFavoriteRepositoryProtocol {

    var characters: AnyPublisher<[MCharacter], Never> { get }

    func removeFavorite(_ character: MCharacter)

}

final class HomeContentFavoriteRepository: HomeContentFavoriteRepositoryProtocol {

    // MARK: - Properties

    var characters: AnyPublisher<[MCharacter], Never> {
        dataStore.favoriteCharacters
    }

    private let dataStore: FavoriteCharacterDataStoreProtocol

    // MARK: - Initializer

    init(dataStore: FavoriteCharacterDataStoreProtocol) {
        self.dataStore = dataStore
    }

    // MARK: - Methods

    func removeFavorite(_ character: MCharacter) {
        dataStore.setFavorite(false, character: character)
    }

}
