//
//  DataStoreAssembly.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Swinject


struct DataStoreAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SearchCharacterDataStoreProtocol.self) { _ in
#if ON_SAMPLE
            return MockSearchCharacterDataStore()
#else
            return SearchCharacterDataStore.init()
#endif
        }

        container.register(FavoriteCharacterDataStoreProtocol.self) { _ in
#if ON_SAMPLE
            return InMemoryFavoriteCharacterDataStore.init()
#else
            return DefaultsFavoriteCharacterDataStore.init()
#endif
        }.inObjectScope(.container)
    }

}
