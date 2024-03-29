//
//  HomeContentFavoriteViewModel.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


final class HomeContentFavoriteViewModel: HomeContentViewModelProtocol {

    // MARK: - Properties

    private let repository: HomeContentFavoriteRepositoryProtocol

    private var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - Initializer

    init(repository: HomeContentFavoriteRepositoryProtocol = HomeContentFavoriteRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func transform(_ input: HomeContentState.Input) -> HomeContentState.Output {
        input.characterDidTapped
            .withUnretained(self)
            .sink { (owner, character) in
                owner.repository.removeFavorite(character)
            }
            .store(in: &cancelBag)

        return .init(
            presenting: .init(
                shouldEnableSearch: Just<Bool>(false).eraseToAnyPublisher(),
                shouldEnableRefresh: Just<Bool>(false).eraseToAnyPublisher(),
                characters: repository.characters,
                favoriteCharacterIds: repository.characters.map { $0.map(\.id) }.eraseToAnyPublisher(),
                isLoading: .empty(),
                error: .empty()
            ),
            routing: .init(route: .empty())
        )
    }

}
