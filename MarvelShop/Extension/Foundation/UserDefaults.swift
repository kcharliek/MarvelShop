//
//  UserDefaults.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


extension UserDefaults {

    func setCodable<T: Codable>(_ object: T, forKey key: String) throws {
        let encodedData = try JSONEncoder().encode(object)

        self.set(encodedData, forKey: key)
    }

    func objectCodable<T: Codable>(forKey key: String) throws -> T? {
        if let encodedData = self.data(forKey: key) {
            return try JSONDecoder().decode(T.self, from: encodedData)
        }

        return nil
    }

}
