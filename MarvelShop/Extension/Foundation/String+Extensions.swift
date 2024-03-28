//
//  String+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import CryptoKit


extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }

    func localized(_ arguments: CVarArg...) -> String {
        String(format: self.localized, arguments)
    }

    func MD5() -> String {
        Insecure.MD5.hash(data: Data(self.utf8))
            .map { String(format: "%02hhx", $0) }
            .joined()
    }

}
