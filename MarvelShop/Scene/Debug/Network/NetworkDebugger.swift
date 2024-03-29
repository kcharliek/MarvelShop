//
//  NetworkDebugger.swift
//  MarvelShop
//
//  Created by Charlie
//

#if DEBUG

import Foundation


final class NetworkDebugger {

    static let shared: NetworkDebugger = .init()

    var histories: [NetworkHistory] = []

    private init() {}

}

#endif
