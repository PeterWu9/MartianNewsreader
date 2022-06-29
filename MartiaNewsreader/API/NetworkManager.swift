//
//  NetworkManager.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

final class NetworkManager {
    
    enum HTTPMethods: String {
        case get
        var description: String {
            return self.rawValue.uppercased()
        }
    }
    
    static let shared = NetworkManager()
    
    
    let decoder = JSONDecoder()
    
    
}

enum NetworkError: Error, LocalizedError {
    case invalidNetworkResponse
}
