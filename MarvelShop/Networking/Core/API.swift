//
//  API.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


final class API {

    private static let session: Session = MURLSession()

    static func request<Request: APIRequest>(_ request: Request, options: [SessionOption] = []) -> AnyPublisher<Request.APIResponse, Error> {
        let urlString: String = request.baseURLString + request.path
        let method = request.method
        let parameters = request.paramters.merging(request.commonParamters, uniquingKeysWith: { $1 } )
        let headers = request.headers.merging(request.commonHeaders, uniquingKeysWith: { $1 } )

        var _options = options
        #if DEBUG
        _options.append(.verbose)
        #endif

        return session
            .request(urlString: urlString, method: method, parameters: parameters, headers: headers, options: _options)
            .decode(type: Request.APIResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
