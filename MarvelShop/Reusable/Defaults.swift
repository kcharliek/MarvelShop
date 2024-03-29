//
//  Defaults.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


enum Defaults {

    static var favoriteCharacterIds: [Int] {
        get {
            (UserDefaults.standard.array(forKey: favoriteCharacterIdsKey) as? [Int]) ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: favoriteCharacterIdsKey)
        }
    }
    private static let favoriteCharacterIdsKey = "favorite_character_ids"

}
