//
//  MockFavoriteCharacterDataStore.swift
//  MarvelShopTests
//
//  Created by Charlie
//

import Foundation
import Combine
@testable import MarvelShop


final class MockFavoriteCharacterDataStore: FavoriteCharacterDataStoreProtocol {

    // MARK: - Properties

    var isFavorite: Bool = false

    var favoriteCharacters: AnyPublisher<[MCharacter], Never> {
        .empty()
    }

    // MARK: - Methods

    func isFavorite(_ character: MCharacter) -> Bool {
        false
    }

    func toggleFavorite(_ character: MCharacter) {
        isFavorite = !isFavorite
    }

    func setFavorite(_ isFavorite: Bool, character: MCharacter) {
        self.isFavorite = isFavorite
    }

    func reset() {
        isFavorite = false
    }

}
