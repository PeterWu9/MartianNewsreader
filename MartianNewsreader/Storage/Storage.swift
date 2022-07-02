//
//  Storage.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/30/22.
//

import Foundation

actor Storage: StorageProvider {
    typealias Key = String
    typealias Value = Articles
    typealias StorageData = [Key: Value]
    
    static let shared = Storage()
    
    private enum Constant {
        static let defaultKey = "saved"
    }
    
    private let storage = UserDefaults.standard
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    func save(_ data: StorageData) async throws {
        let encoded = try encoder.encode(data)
        storage.set(encoded, forKey: Constant.defaultKey)
    }
    
    func retrieveData(for key: Key) async throws -> Articles {
        guard
            let data = storage.object(forKey: Constant.defaultKey) as? Data,
            let decoded = try? decoder.decode(StorageData.self, from: data),
            let articles = decoded[key] else {
            throw StorageError.retrieveDataError
        }
        return articles
    }
    
    enum StorageError: Error, LocalizedError {
        case retrieveDataError
    }
}
