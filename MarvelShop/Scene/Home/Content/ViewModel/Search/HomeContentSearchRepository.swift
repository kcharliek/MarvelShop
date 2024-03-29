//
//  HomeContentSearchRepository.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


protocol HomeContentSearchRepositoryProtocol {

    var characters: AnyPublisher<[MCharacter], Never> { get }
    var favoriteCharacterIds: AnyPublisher<[Int], Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var error: AnyPublisher<Error, Never> { get }

    func search(_ query: String)
    func refresh()
    func loadNext()
    func toggleFavorite(_ character: MCharacter)

}

final class HomeContentSearchRepository: HomeContentSearchRepositoryProtocol {

    // MARK: - Properties

    // Stream
    var characters: AnyPublisher<[MCharacter], Never> {
        _characters
            .map { $0.sorted(by: { $0.key < $1.key }).flatMap { $1 } }
            .eraseToAnyPublisher()
    }
    var favoriteCharacterIds: AnyPublisher<[Int], Never> {
        favoriteDataStore.favoriteCharacters
            .map { $0.map(\.id) }
            .eraseToAnyPublisher()
    }
    var isLoading: AnyPublisher<Bool, Never> {
        loadingCount
            .map { $0 > 0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    var error: AnyPublisher<Error, Never> {
        _error.eraseToAnyPublisher()
    }
    private let _characters: CurrentValueSubject<[Int: [MCharacter]], Never> = .init([:])
    private let _favoriteCharacterIds: PassthroughSubject<[Int], Never> = .init()
    private let loadingCount: CurrentValueSubject<Int, Never> = .init(0)
    private let _error: PassthroughSubject<Error, Never> = .init()
    private var cancelBag: Set<AnyCancellable> = .init()

    // DataStore
    @Inject private var dataStore: SearchCharacterDataStoreProtocol
    @Inject private var favoriteDataStore: FavoriteCharacterDataStoreProtocol

    // State
    private var query: String = ""
    private var currentPage: Int = 0
    private var hasNext: Bool = true

    // MARK: - Methods

    func search(_ query: String) {
        self.query = query

        refresh()
    }

    func refresh() {
        cancelBag = .init()

        hasNext = true
        currentPage = 0
        loadingCount.send(1)

        requestSearch()
    }

    func loadNext() {
        guard hasNext else {
            return
        }

        currentPage += 1
        loadingCount.send(loadingCount.value + 1)

        requestSearch()
    }

    func toggleFavorite(_ character: MCharacter) {
        favoriteDataStore.toggleFavorite(character)
    }

    private func requestSearch() {
        let page = currentPage

        dataStore.searchCharacter(query: self.query, page: page)
            .withUnretained(self)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case let .failure(error) = completion {
                        self._error.send(error)
                    }

                    self.loadingCount.send(loadingCount.value - 1)
                },
                receiveValue: { (owner, result) in
                    let newItems = {
                        if page == 0 {
                            return [0: result.items]
                        } else {
                            return owner._characters.value.merging([page: result.items], uniquingKeysWith: { $1 })
                        }
                    }()

                    owner._characters.send(newItems)
                    owner.hasNext = result.hasNext
                }
            )
            .store(in: &cancelBag)
    }

}
