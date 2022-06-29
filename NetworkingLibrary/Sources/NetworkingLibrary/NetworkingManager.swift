//
//  NetworkingManager.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/28/22.
//  Copyright © 2022 Peter Wu. All rights reserved.
//

import Foundation

public final class NetworkingManager {
        
    public static let shared = NetworkingManager()
    
    public func get<T>(url: URL, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        
        // ✅ Tested in create(_:for) and response(_, for)
        let (data, response) = try await response(.get, for: url)
        
        // Throw error to forego data decoding if task has been cancelled
        guard !Task.isCancelled else {
            throw NetworkError.networkTaskCancelled
        }
        
        // ✅ Tested
        try checkResponseAndStatusCode(response)
        
        // Decode data by meta type
        // Throw APIError.dataDecodingFailure if decode failed.
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.dataDecodingFailure(data)
        }
    }
    
    public func get<T>(url: String, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl(url: url)
        }
        
        return try await get(url: url, decoder: decoder)
    }
    
    enum RequestMethod {
        
        case get
        
        var description: String {
            switch self {
            case .get:
                return "GET"
            }
        }
    }
    
    public func fetch(url: URL) async throws -> Data {
        
        // ✅ Tested
        let (data, response) = try await response(.get, for: url)
        
        // Throw error to forego data decoding if task has been cancelled
        guard !Task.isCancelled else {
            throw NetworkError.networkTaskCancelled
        }
        
        // ✅ Tested
        try checkResponseAndStatusCode(response)
        
        return data
    }
    
    public func fetch(url: String) async throws -> Data {
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl(url: url)
        }
        
        return try await fetch(url: url)
    }
    
    func checkResponseAndStatusCode(_ response: URLResponse) throws {
        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            (200..<300).contains(statusCode) else {
            throw NetworkError.invalidNetworkResponse(response: response)
        }
    }
    
    func create(_ method: RequestMethod, for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        return request
    }
    
    func response(_ method: RequestMethod, for url: URL) async throws -> (Data, URLResponse) {
        let request = create(method, for: url)
        return try await URLSession.shared.data(for: request)
    }
    
}
