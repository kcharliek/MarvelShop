//
//  UserDefaultsFavoriteCharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


final class UserDefaultsFavoriteCharacterDataStore: FavoriteCharacterDataStoreProtocol {

    func fetchFavoriteCharacterIds() -> [Int] {
        Defaults.favoriteCharacterIds
    }

    func isFavorite(_ characterId: Int) -> Bool {
        Defaults.favoriteCharacterIds.contains(characterId)
    }

    func toggleFavorite(_ characterId: Int) {
        let toggled = !isFavorite(characterId)
        setFavorite(toggled, characterId: characterId)
    }

    func setFavorite(_ isFavorite: Bool, characterId: Int) {
        let oldValue = Defaults.favoriteCharacterIds

        if isFavorite {
            guard oldValue.contains(characterId) == false else {
                return
            }
            var newValue = oldValue
            newValue.append(characterId)
            Defaults.favoriteCharacterIds = newValue
        } else {
            guard oldValue.contains(characterId) else {
                return
            }
            var newValue = oldValue
            newValue.removeAll(where: { $0 == characterId })
            Defaults.favoriteCharacterIds = newValue
        }
    }

}
