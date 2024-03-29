//
//  InMemoryFavoriteCharacterDataStore.swift
//  MarvelShop
//
//  Created by Charlie
//

#if ON_SAMPLE

import Foundation
import Combine


final class InMemoryFavoriteCharacterDataStore: FavoriteCharacterDataStoreProtocol {

    // MARK: - Properties

    var favoriteCharacters: AnyPublisher<[MCharacter], Never> {
        _favoriteCharacters.eraseToAnyPublisher()
    }

    private let _favoriteCharacters: CurrentValueSubject<[MCharacter], Never> = .init([])

    // MARK: - Methods

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
            _favoriteCharacters.send(newValue.suffix(Constant.maximumFavoriteCount))
        } else {
            guard self.isFavorite(character) else {
                return
            }
            var newValue = fetchFavoriteCharacters()
            newValue.removeAll(where: { $0.id == character.id })
            _favoriteCharacters.send(newValue.suffix(Constant.maximumFavoriteCount))
        }
    }

    private func fetchFavoriteCharacters() -> [MCharacter] {
        _favoriteCharacters.value
    }

}

#endif
