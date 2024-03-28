//
//  Publisher+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


extension Publisher {

    func withLatestFrom<Other: Publisher, Result>(
        _ other: Other,
        resultSelector: @escaping (Output, Other.Output) -> Result
    ) -> AnyPublisher<Result, Failure> where Other.Failure == Failure {
        let upstream = share()

        return other
            .map { second in upstream.map { resultSelector($0, second) } }
            .switchToLatest()
            .zip(upstream)
            .map(\.0)
            .eraseToAnyPublisher()
    }

}

extension Publisher {

    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] upstreamValue in
            guard let object = object else {
                return nil
            }

            return (object, upstreamValue)
        }
    }

}

extension Publisher where Failure == Never {

    func mapError() -> Publishers.MapError<Self, Error> {
        mapError { $0 as Error }
    }

}

extension Publisher {

    static func empty() -> AnyPublisher<Self.Output, Self.Failure> {
        Empty<Self.Output, Self.Failure>.init(completeImmediately: false)
            .eraseToAnyPublisher()
    }

}
