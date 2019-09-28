//
//  StorageManager.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init(decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func saveData<T: Codable>(value: T, for key: StorageKeys) throws {
        let data = try encoder.encode(value)
        if DBManager.shared.getValueBy(key: key.rawValue) != Data("".utf8){
            DBManager.shared.update(value: data, forKey: key.rawValue)
        } else {
            DBManager.shared.insert(value: data, forKey: key.rawValue)
        }
    }
    
    func fetchData<T: Codable>(for key: StorageKeys) throws -> T {
        let data = DBManager.shared.getValueBy(key: key.rawValue)
        let model = try decoder.decode(T.self, from: data)
        return model
    }
}
