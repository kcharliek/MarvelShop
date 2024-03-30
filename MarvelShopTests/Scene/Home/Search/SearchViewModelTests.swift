//
//  SearchViewModelTests.swift
//  MarvelShopTests
//
//  Created by Charlie
//

import XCTest
import Combine
@testable import MarvelShop


final class SearchViewModelTests: XCTestCase {

    // MARK: - Properties

    private let searchCharacterDataStore = TMockSearchCharacterDataStore()
    private let favoriteCharacterDataStore = MockFavoriteCharacterDataStore()

    private lazy var repository = HomeContentSearchRepository(dataStore: searchCharacterDataStore, favoriteDataStore: favoriteCharacterDataStore)
    private lazy var viewModel = HomeContentSearchViewModel(repository: repository)

    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    private let queryPublisher: PassthroughSubject<String, Never> = .init()
    private let refreshPublisher: PassthroughSubject<Void, Never> = .init()
    private let loadNextPublisher: PassthroughSubject<Void, Never> = .init()
    private let characterDidTappedPublisher: PassthroughSubject<MCharacter, Never> = .init()

    private var output: HomeContentState.Output!

    // MARK: - Life Cycle

    override func setUp() {
        output = viewModel.transform(
            .init(
                viewDidLoad: viewDidLoadPublisher.eraseToAnyPublisher(),
                query: queryPublisher.eraseToAnyPublisher(),
                refresh: refreshPublisher.eraseToAnyPublisher(),
                loadNext: loadNextPublisher.eraseToAnyPublisher(),
                characterDidTapped: characterDidTappedPublisher.eraseToAnyPublisher()
            )
        )
    }

    override func tearDown() {
        searchCharacterDataStore.reset()
        favoriteCharacterDataStore.reset()
    }

    // MARK: - Tests

    func test_viewDidLoad호출했을때_빈텍스트검색여부() {
        // given
        let exp = expectation(description: #function)
        var characterName: String?
        let cancelable = output.presenting.characters
            .sink(
                receiveValue: { characters in
                    characterName = characters.first?.name

                    exp.fulfill()
                }
            )

        // when
        viewDidLoadPublisher.send(())

        wait(for: [exp], timeout: 0.1)

        // then
        XCTAssertEqual(searchCharacterDataStore.lastRequestQuery, "")
        XCTAssertTrue(characterName == "empty")

        cancelable.cancel()
    }

    func test_쿼리검색했을때_캐릭터응답여부() {
        // given
        let exp = expectation(description: #function)
        var characterName: String?
        let cancelable = output.presenting.characters
            .sink(
                receiveValue: { characters in
                    characterName = characters.first?.name
                    exp.fulfill()
                }
            )

        // when
        queryPublisher.send("query1")

        wait(for: [exp], timeout: 0.1)

        // then
        XCTAssertEqual(searchCharacterDataStore.lastRequestQuery, "query1")
        XCTAssertTrue(characterName == "query1")

        cancelable.cancel()
    }

    func test_쿼리검색이후_다음페이지요청했을때_다음페이지요청및누적응답여부() {
        // given
        let exp = expectation(description: #function)
        var results: [[MCharacter]] = []
        var count: Int = 0

        let cancelable = output.presenting.characters
            .sink(receiveValue: { characters in
                count += 1

                results.append(characters)

                if count == 2 {
                    exp.fulfill()
                }
            })
        queryPublisher.send("query1")

        // when
        loadNextPublisher.send(())

        wait(for: [exp], timeout: 0.1)

        // then
        XCTAssertTrue(results[0].count == 1) // page 0
        XCTAssertTrue(results[1].count == 2) // page 1

        cancelable.cancel()
    }

    func test_검색이후_새로고침했을때_첫페이지응답여부() {
        // given
        let exp = expectation(description: #function)
        var results: [[MCharacter]] = []
        var count: Int = 0

        let cancelable = output.presenting.characters
            .sink(receiveValue: { characters in
                count += 1

                results.append(characters)

                if count == 3 {
                    exp.fulfill()
                }
            })
        queryPublisher.send("query1")
        loadNextPublisher.send(())

        // when
        refreshPublisher.send(())

        wait(for: [exp], timeout: 0.1)

        // then
        XCTAssertTrue(searchCharacterDataStore.lastRequestPage == 0)
        XCTAssertTrue(results[0].count == 1) // page 0
        XCTAssertTrue(results[1].count == 2) // page 1
        XCTAssertTrue(results[2].count == 1) // page 0

        cancelable.cancel()
    }

    func test_캐릭터터치시_favorite토글요청여부() {
        // given
        XCTAssertTrue(favoriteCharacterDataStore.isFavorite == false)
        let emptyCharacter: MCharacter = .init(id: 0, name: "", description: "", thumbnailImageURLString: "")

        // when 1
        characterDidTappedPublisher.send(emptyCharacter)

        // then 1
        XCTAssertTrue(favoriteCharacterDataStore.isFavorite == true)

        // when 2
        characterDidTappedPublisher.send(emptyCharacter)

        // then 2
        XCTAssertTrue(favoriteCharacterDataStore.isFavorite == false)
    }

}
