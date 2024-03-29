//
//  MCharacter.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


struct MCharacter: Codable {

    let id: Int
    let name: String
    let description: String
    let thumbnailImageURLString: String

}

extension MCharacter: CharacterCollectionViewCellModel {

    var title: String {
        name
    }
    
    var subtitle: String {
        description
    }
    
    var imageURLString: String {
        thumbnailImageURLString
    }

}
