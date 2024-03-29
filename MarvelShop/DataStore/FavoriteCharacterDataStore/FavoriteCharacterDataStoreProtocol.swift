//
//  FavoriteCharacterDataStoreProtocol.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


protocol FavoriteCharacterDataStoreProtocol {

    func fetchFavoriteCharacterIds() -> [Int]

    func isFavorite(_ characterId: Int) -> Bool

    func toggleFavorite(_ characterId: Int)

    func setFavorite(_ isFavorite: Bool, characterId: Int)

}
