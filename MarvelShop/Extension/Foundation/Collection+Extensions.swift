//
//  Collection+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

}
