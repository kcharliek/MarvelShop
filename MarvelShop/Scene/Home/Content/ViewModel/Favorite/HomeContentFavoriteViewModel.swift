//
//  HomeContentFavoriteViewModel.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation


struct HomeContentFavoriteViewModel: HomeContentViewModelProtocol {
    func transform(_ input: HomeContentState.Input) -> HomeContentState.Output {
        return .init(
            presenting: .init(
                shouldEnableSearch: .empty(),
                characters: .empty(),
                isLoading: .empty(),
                error: .empty()
            ),
            routing: .init(route: .empty())
        )
    }

}
