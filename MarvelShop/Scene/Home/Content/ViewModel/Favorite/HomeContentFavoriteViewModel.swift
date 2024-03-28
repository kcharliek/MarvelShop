//
//  HomeContentFavoriteViewModel.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


struct HomeContentFavoriteViewModel: HomeContentViewModelProtocol {
    
    func transform(_ input: HomeContentState.Input) -> HomeContentState.Output {
        return .init(
            presenting: .init(
                shouldEnableSearch: Just<Bool>(false).eraseToAnyPublisher(),
                characters: .empty(),
                isLoading: .empty(),
                error: .empty()
            ),
            routing: .init(route: .empty())
        )
    }

}
