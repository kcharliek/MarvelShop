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

    private var cancelBag: Set<AnyCancellable> = .init()

    init(repository: HomeContentSearchRepositoryProtocol = HomeContentSearchRepository()) {
        self.repository = repository
    }

    func transform(_ input: HomeContentState.Input) -> HomeContentState.Output {
        input.viewDidLoad
            .withUnretained(self)
            .sink { (owner, _) in
                owner.repository.search("")
            }
            .store(in: &cancelBag)

        input.query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .filter { $0.isEmpty || $0.count >= 2 }
            .withUnretained(self)
            .sink { (owner, query) in
                owner.repository.search(query)
            }
            .store(in: &cancelBag)

        input.refresh
            .withUnretained(self)
            .sink { (owner, _) in
                owner.repository.refresh()
            }
            .store(in: &cancelBag)

        input.loadNext
            .withUnretained(self)
            .sink { (owner, _) in
                owner.repository.loadNext()
            }
            .store(in: &cancelBag)

        input.characterDidTapped
            .withUnretained(self)
            .sink { (owner, character) in
                owner.repository.toggleFavorite(character)
            }
            .store(in: &cancelBag)

        return .init(
            presenting: .init(
                shouldEnableSearch: Just<Bool>(true).eraseToAnyPublisher(),
                shouldEnableRefresh: Just<Bool>(true).eraseToAnyPublisher(),
                characters: repository.characters,
                favoriteCharacterIds: repository.favoriteCharacterIds,
                isLoading: repository.isLoading,
                error: repository.error
            ),
            routing: .init(route: .empty())
        )
    }

}
