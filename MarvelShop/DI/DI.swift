//
//  DI.swift
//  MarvelShop
//
//  Created by Charlie
//

import Swinject


final class DI {

    static let shared = DI()

    private let container = Container()
    private let assembler: Assembler

    private init() {
        assembler = Assembler(
            [
                ViewModelAssembly(),
                DataStoreAssembly(),
                NetworkingAssembly()
            ],
            container: container
        )
    }

    func resolve<T>(_ serviceType: T.Type, name: String? = nil) -> T? {
        container.resolve(serviceType, name: name)
    }
    
}
