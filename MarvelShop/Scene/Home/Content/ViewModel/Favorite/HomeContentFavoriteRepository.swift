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

    @Inject private var dataStore: FavoriteCharacterDataStoreProtocol

    // MARK: - Methods

    func removeFavorite(_ character: MCharacter) {
        dataStore.setFavorite(false, character: character)
    }

}
