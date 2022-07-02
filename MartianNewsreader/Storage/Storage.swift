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
    typealias Data = [Key: Value]
    
    func save(_ data: Data) async {
        fatalError()
    }
    
    func retrieveData(for key: String) async {
        fatalError()
    }
}
