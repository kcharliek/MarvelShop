//
//  HomeContentSearchRepository.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


protocol HomeContentSearchRepositoryProtocol {

    func searchCharacter(_ query: String) -> AnyPublisher<[MCharacter], Error>

}

final class HomeContentSearchRepository: HomeContentSearchRepositoryProtocol {

    func searchCharacter(_ query: String) -> AnyPublisher<[MCharacter], Error> {
        Just<[MCharacter]>.init([
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300"),
            .init(id: UUID().hashValue, name: "이름", description: "설명", thumbnailImageURLString: "https://picsum.photos/200/300")
        ])
        .mapError()
        .eraseToAnyPublisher()
    }

}
