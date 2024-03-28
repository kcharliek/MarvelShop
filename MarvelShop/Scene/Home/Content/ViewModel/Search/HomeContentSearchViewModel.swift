//
//  HomeContentSearchViewModel.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


final class HomeContentSearchViewModel: HomeContentViewModelProtocol {

    private let repository: HomeContentSearchRepositoryProtocol

    init(repository: HomeContentSearchRepositoryProtocol = HomeContentSearchRepository()) {
        self.repository = repository
    }

    func transform(_ input: HomeContentState.Input) -> HomeContentState.Output {

        let items: AnyPublisher<[MCharacter], Never> = input.viewDidLoad
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.repository.searchCharacter("")
                    .catch { _ in
                        Empty<[MCharacter], Never>.init(completeImmediately: false)
                    }
            }
            .eraseToAnyPublisher()

        return .init(
            presenting: .init(
                shouldEnableSearch: Just<Bool>(true).eraseToAnyPublisher(),
                characters: items,
                isLoading: .empty(),
                error: .empty()
            ),
            routing: .init(route: .empty())
        )
    }

}

