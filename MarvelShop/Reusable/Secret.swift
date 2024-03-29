//
//  Secret.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


enum Secret {

    static var API_KEY_PUBLIC: String {
        guard let _value: String = InfoPlist.value(forKey: "API_KEY_PUBLIC") else{
            assertionFailure("Secret.xcconfig 누락. 동료에게 해당 파일을 요청하세요")
            return ""
        }
        return _value
    }

    static var API_KEY_PRIVATE: String {
        guard let _value: String = InfoPlist.value(forKey: "API_KEY_PRIVATE") else{
            assertionFailure("Secret.xcconfig 누락. 동료에게 해당 파일을 요청하세요")
            return ""
        }
        return _value
    }

}
