//
//  ViewModelAssembly.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Swinject


struct ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register(HomeContentSearchRepositoryProtocol.self, factory: { container in
            let dataStore = container.resolve(SearchCharacterDataStoreProtocol.self)!
            let favoriteDataStore = container.resolve(FavoriteCharacterDataStoreProtocol.self)!

            return HomeContentSearchRepository(
                dataStore: dataStore,
                favoriteDataStore: favoriteDataStore
            )
        })

        container.register(HomeContentFavoriteRepositoryProtocol.self, factory: { container in
            let dataStore = container.resolve(FavoriteCharacterDataStoreProtocol.self)!

            return HomeContentFavoriteRepository(dataStore: dataStore)
        })

        container.register(HomeContentFavoriteViewModel.self, factory: { container in
            let repository = container.resolve(HomeContentFavoriteRepositoryProtocol.self)!

            return HomeContentFavoriteViewModel(repository: repository)
        })

        container.register(HomeContentViewModelProtocol.self, name: "search") { container in
            let repository = container.resolve(HomeContentSearchRepositoryProtocol.self)!

            return HomeContentSearchViewModel(repository: repository)
        }

        container.register(HomeContentViewModelProtocol.self, name: "favorite") { container in
            let repository = container.resolve(HomeContentFavoriteRepositoryProtocol.self)!

            return HomeContentFavoriteViewModel(repository: repository)
        }
    }

}
