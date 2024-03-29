//
//  Defaults.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


final class Defaults {

    static let shared: Defaults = .init()

    private let userDefaults: UserDefaults = .standard

    private lazy var _favoriteCharactersPublisher: CurrentValueSubject<[MCharacter], Never> = {
        let objects: [MCharacter] = (try? userDefaults.objectCodable(forKey: favoriteCharactersKey)) ?? []
        return CurrentValueSubject<[MCharacter], Never>.init(objects)
    }()

    private init() { }

}

extension Defaults {

    var favoriteCharactersPublisher: AnyPublisher<[MCharacter], Never> {
        _favoriteCharactersPublisher.eraseToAnyPublisher()
    }

    func fetchFavoriteCharacters() -> [MCharacter] {
        _favoriteCharactersPublisher.value
    }

    func setFavoriteCharacters(_ newValue: [MCharacter]) {
        do {
            try userDefaults.setCodable(newValue, forKey: favoriteCharactersKey)
            _favoriteCharactersPublisher.send(newValue)
        } catch {
            print("Error - set favoriteCharacters - \(error)")
        }
    }

    private var favoriteCharactersKey: String {
        "favorite_characters"
    }

}
