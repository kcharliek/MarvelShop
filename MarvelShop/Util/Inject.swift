//
//  Inject.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Swinject


@propertyWrapper
struct Inject<T> {

    private let name: String?

    init(_ name: String? = nil) {
        self.name = name
    }

    lazy var wrappedValue: T = {
        if let resolved = DI.shared.resolve(T.self, name: name) {
            return resolved
        } else {
            fatalError("Dependency not found: \(String(describing: T.self))")
        }
    }()

}
