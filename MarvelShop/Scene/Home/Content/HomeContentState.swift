//
//  HomeContentState.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


enum HomeContentState {

    struct Input {

        let viewDidLoad: AnyPublisher<Void, Never>
        let query: AnyPublisher<String, Never>
        let refresh: AnyPublisher<Void, Never>
        let loadNext: AnyPublisher<Void, Never>
        let characterDidTapped: AnyPublisher<MCharacter, Never>

    }

    struct Output {

        let presenting: Presenting
        let routing: Routing

        struct Presenting {

            let shouldEnableSearch: AnyPublisher<Bool, Never>
            let shouldEnableRefresh: AnyPublisher<Bool, Never>
            let characters: AnyPublisher<[MCharacter], Never>
            let favoriteCharacterIds: AnyPublisher<[Int], Never>
            let isLoading: AnyPublisher<Bool, Never>
            let error: AnyPublisher<Error, Never>

        }

        struct Routing {

            let route: AnyPublisher<Target, Never>

            enum Target {

                case none

            }

        }

    }


}
