//
//  Storage.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/30/22.
//

import Foundation

actor StorageService<Value>: StorageServiceProvider where Value: Codable {
        
    private let defaultKey = "saved"
    private let storage = UserDefaults.standard
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    func save(_ data: Value) async throws {
        let encoded = try encoder.encode(data)
        storage.set(encoded, forKey: defaultKey)
    }
    
    func retrieveData() async throws -> Value? {
        if let data = storage.object(forKey: defaultKey) as? Data {
            guard
                let decoded = try? decoder.decode(Value.self, from: data) else {
                throw StorageError.decodingError
            }
            return decoded
        } else {
            return nil
        }
    }

    enum StorageError: Error, LocalizedError {
        case decodingError
    }
}
