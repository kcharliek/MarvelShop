//
//  NetworkingAssembly.swift
//  MarvelShop
//
//  Created by Charlie
//


import Foundation
import Swinject


struct NetworkingAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Session.self) { _ in
            MURLSession.init()
        }.inObjectScope(.container)
    }

}
