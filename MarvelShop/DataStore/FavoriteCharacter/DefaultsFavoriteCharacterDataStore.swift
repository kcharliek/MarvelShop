//
//  DefaultsFavoriteCharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


final class DefaultsFavoriteCharacterDataStore: FavoriteCharacterDataStoreProtocol {

    var favoriteCharacters: AnyPublisher<[MCharacter], Never> {
        Defaults.shared.favoriteCharactersPublisher
    }

    func isFavorite(_ character: MCharacter) -> Bool {
        let favoriteCharacterIds = fetchFavoriteCharacters().map { $0.id }
        return favoriteCharacterIds.contains(character.id)
    }

    func toggleFavorite(_ character: MCharacter) {
        let toggled = !isFavorite(character)
        setFavorite(toggled, character: character)
    }

    func setFavorite(_ isFavorite: Bool, character: MCharacter) {
        if isFavorite {
            guard self.isFavorite(character) == false else {
                return
            }
            var newValue = fetchFavoriteCharacters()
            newValue.append(character)
            Defaults.shared.setFavoriteCharacters(newValue.suffix(Constant.maximumFavoriteCount))
        } else {
            guard self.isFavorite(character) else {
                return
            }
            var newValue = fetchFavoriteCharacters()
            newValue.removeAll(where: { $0.id == character.id })
            Defaults.shared.setFavoriteCharacters(newValue)
        }
    }

    private func fetchFavoriteCharacters() -> [MCharacter] {
        Defaults.shared.fetchFavoriteCharacters()
    }

}
