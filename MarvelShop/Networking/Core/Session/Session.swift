//
//  Session.swift
//  MarvelShop
//
//  Created by Charlie
//

import Foundation
import Combine


enum SessionOption {

    case verbose

}

protocol Session {

    func request(urlString: String, method: HTTPMethod, parameters: [String: Any], headers: [String: String], options: [SessionOption]) -> AnyPublisher<Data, Error>

}
