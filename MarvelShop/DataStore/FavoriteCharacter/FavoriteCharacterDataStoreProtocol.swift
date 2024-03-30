//
//  FavoriteCharacterDataStoreProtocol.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


protocol FavoriteCharacterDataStoreProtocol {

    var favoriteCharacters: AnyPublisher<[MCharacter], Never> { get }

    func isFavorite(_ character: MCharacter) -> Bool

    func toggleFavorite(_ character: MCharacter)

    func setFavorite(_ isFavorite: Bool, character: MCharacter)

}
