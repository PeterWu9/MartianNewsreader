//
//  NetworkError.swift
//  NetworkingLibrary
//
//  Created by Peter Wu on 6/28/22.
//  Copyright © 2022 Peter Wu. All rights reserved.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Equatable {
    
    public var errorDescription: String? {
        switch self {
        case .invalidNetworkResponse(let response):
            return "Invalid network response \(response)"
        case .dataDecodingFailure(let data):
            return "Unable to decode data \(data)"
        case .imageDecodingFailure(let data):
            return "Unable to create image from data: \(data)"
        case .networkTaskCancelled:
            return "Network task cancelled"
        case .invalidUrl(let url):
            return "Invalid URL: \(url)"
        }
    }
    
    case invalidNetworkResponse(response: URLResponse)
    case dataDecodingFailure(Data)
    case imageDecodingFailure(Data)
    case networkTaskCancelled
    case invalidUrl(url: String)
}


