//
//  MURLSession.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


enum MURLSessionError: Error {

    case invalidURL
    case urlError(_ error: URLError)

}

final class MURLSession: Session {

    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return .init(configuration: config)
    }()

    func request(urlString: String, method: HTTPMethod, parameters: [String : Any], headers: [String : String], options: [SessionOption]) -> AnyPublisher<Data, Error> {
        do {
            let urlRequest = try makeURLRequest(urlString: urlString, method: method, parameters: parameters, headers: headers)

            let verbose = options.contains(.verbose)

            if verbose {
                print("🚀🚀 Request Started: \(urlRequest) 🚀🚀")
            }

            return Self.session
                .dataTaskPublisher(for: urlRequest)
                .map {
                    if verbose {
                        print("⚡️⚡️ Response Received: \($0.data.jsonString() ?? "NO JSON") ⚡️⚡️")
                    }
                    return $0.data
                }
                .mapError { MURLSessionError.urlError($0) }
                .eraseToAnyPublisher()
        } catch (let error) {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func makeURLRequest(urlString: String, method: HTTPMethod, parameters: [String : Any], headers: [String : String]) throws -> URLRequest {
        let url = try makeURL(urlString: urlString, method: method, parameters: parameters)

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue

        urlRequest.httpBody = try makeBody(method: method, parameters: parameters)

        headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return urlRequest
    }

    private func makeURL(urlString: String, method: HTTPMethod, parameters: [String: Any]) throws -> URL {
        if method == .get {
            guard var urlComponents = URLComponents(string: urlString) else {
                throw MURLSessionError.invalidURL
            }

            var queryItems = [URLQueryItem]()

            parameters.forEach {
                queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }

            urlComponents.queryItems = queryItems

            guard let url = urlComponents.url else {
                throw MURLSessionError.invalidURL
            }

            return url
        } else {
            guard let url = URL(string: urlString) else {
                throw MURLSessionError.invalidURL
            }

            return url
        }
    }

    private func makeBody(method: HTTPMethod, parameters: [String: Any]) throws -> Data? {
        if method == .get {
            return nil
        } else {
            return try JSONSerialization.data(withJSONObject: parameters)
        }
    }

}

private extension Data {

    func jsonString() -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        else {
            return nil
        }
        return String(decoding: jsonData, as: UTF8.self)
    }

}
