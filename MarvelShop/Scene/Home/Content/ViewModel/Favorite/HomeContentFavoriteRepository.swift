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

    var characters: AnyPublisher<[MCharacter], Never> {
        dataStore.favoriteCharacters
    }

    private let dataStore: FavoriteCharacterDataStoreProtocol

    init(dataStore: FavoriteCharacterDataStoreProtocol = UserDefaultsFavoriteCharacterDataStore()) {
        self.dataStore = dataStore
    }

    func removeFavorite(_ character: MCharacter) {
        dataStore.setFavorite(false, character: character)
    }

}
