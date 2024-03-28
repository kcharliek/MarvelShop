//
//  String+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }

    func localized(_ arguments: CVarArg...) -> String {
        String(format: self.localized, arguments)
    }

}
