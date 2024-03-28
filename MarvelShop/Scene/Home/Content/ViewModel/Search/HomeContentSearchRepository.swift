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
    var isLoading: AnyPublisher<Bool, Never> { get }
    var error: AnyPublisher<Error, Never> { get }

    func search(_ query: String)
    func refresh()
    func loadNext()
    func toggleFavorite(_ id: Int)

}

final class HomeContentSearchRepository: HomeContentSearchRepositoryProtocol {

    // MARK: - Properties

    var characters: AnyPublisher<[MCharacter], Never> {
        _characters
            .map { $0.sorted(by: { $0.key < $1.key }).flatMap { $1 } }
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

    private let dataStore: SearchCharacterDataStoreProtocol
    private var query: String = ""
    private var currentPage: Int = 0
    private var hasNext: Bool = true

    private let _characters: CurrentValueSubject<[Int: [MCharacter]], Never> = .init([:])
    private let loadingCount: CurrentValueSubject<Int, Never> = .init(0)
    private let _error: PassthroughSubject<Error, Never> = .init()
    private var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - Initializer

    init(dataStore: SearchCharacterDataStoreProtocol = SearchCharacterDataStore()) {
        self.dataStore = dataStore
    }

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

        _search()
    }

    func loadNext() {
        guard hasNext else {
            return
        }

        currentPage += 1
        loadingCount.send(loadingCount.value + 1)

        _search()
    }

    func toggleFavorite(_ id: Int) {
        
    }

    private func _search() {
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
