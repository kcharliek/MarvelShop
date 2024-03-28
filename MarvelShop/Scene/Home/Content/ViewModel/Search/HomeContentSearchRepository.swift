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
        _characters.eraseToAnyPublisher()
    }

    var isLoading: AnyPublisher<Bool, Never> {
        _isLoading.eraseToAnyPublisher()
    }

    var error: AnyPublisher<Error, Never> {
        _error.eraseToAnyPublisher()
    }

    private let dataStore: CharacterDataStoreProtocol
    private var query: String = ""

    private let _characters: PassthroughSubject<[MCharacter], Never> = .init()
    private let _isLoading: PassthroughSubject<Bool, Never> = .init()
    private let _error: PassthroughSubject<Error, Never> = .init()

    private let refreshPublisher: PassthroughSubject<Void, Never> = .init()
    private let loadNextPublisher: PassthroughSubject<Void, Never> = .init()

    private var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - Initializer

    init(dataStore: CharacterDataStoreProtocol = CharacterDataStore()) {
        self.dataStore = dataStore
        bind()
    }

    // MARK: - Methods

    func search(_ query: String) {
        self.query = query
        refreshPublisher.send(())
    }

    func refresh() {
        refreshPublisher.send(())
    }

    func loadNext() {
        loadNextPublisher.send(())
    }

    func toggleFavorite(_ id: Int) {
        
    }

    private func bind() {
        refreshPublisher
            .withUnretained(self)
            .flatMap {
                $0.0.dataStore.searchCharacter(query: self.query, page: 0)
                    .catch { _ in
                        Empty<[MCharacter], Never>.init(completeImmediately: false).eraseToAnyPublisher()

                    }
            }
            .subscribe(_characters)
            .store(in: &cancelBag)
    }

}
