//
//  InfoPlist.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


enum InfoPlist {

    static func value(forKey key: String) -> String? {
        guard let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let infoDict = NSDictionary(contentsOfFile: infoPlistPath),
              let value = infoDict[key] as? String
        else {
            return nil
        }
        return value
    }

}
