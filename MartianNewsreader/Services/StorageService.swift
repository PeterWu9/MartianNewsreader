//
//  Storage.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/30/22.
//

import Foundation

actor StorageService<StorageKey, Value>: StorageServiceProvider where StorageKey: Codable & Hashable, Value: Codable {
    
    typealias Key = StorageKey
    typealias Value = Value
    typealias StorageData = [Key: Value]
    
    private let defaultKey = "saved"
    private let storage = UserDefaults.standard
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    func save(_ data: StorageData) async throws {
        let encoded = try encoder.encode(data)
        storage.set(encoded, forKey: defaultKey)
    }
    
    func retrieveData(for key: StorageKey) async throws -> Value {
        guard
            let data = storage.object(forKey: defaultKey) as? Data,
            let decoded = try? decoder.decode(StorageData.self, from: data),
            let items = decoded[key] else {
            throw StorageError.retrieveDataError
        }
        return items
    }

    enum StorageError: Error, LocalizedError {
        case retrieveDataError
    }
}
