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
        Container.loggingFunction = nil
        assembler = Assembler(
            [
                NetworkingAssembly(),
                DataStoreAssembly()
            ],
            container: container
        )
    }

    func resolve<T>(_ serviceType: T.Type, name: String? = nil) -> T? {
        container.resolve(serviceType, name: name)
    }
    
}
