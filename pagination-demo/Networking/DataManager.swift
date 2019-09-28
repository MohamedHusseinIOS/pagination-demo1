//
//  DataManager.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init(){}
    
    private func handelResponseData<T: BaseModel>( response: ResponseEnum, model: T.Type, completion: @escaping NetworkManager.responseCallback){
        switch response {
        case .success(let value):
            guard let value = value else { return }
            let responseData = model.decodeJSON(value, To: model, format: .convertFromSnakeCase)
            completion(.success(responseData))
        case .failure(let error, let data):
            completion(.failure(error, data))
        }
    }
    
    func getDataFormDB<T: Codable>(key: StorageKeys, model: T.Type, completion: @escaping NetworkManager.responseCallback){
        do{
            let model = try StorageManager.shared.fetchData(for: key) as T
            completion(.success(model))
        } catch let error {
            completion(.failure(nil, ErrorModel(message: error.localizedDescription)))
        }
    }
    
    func getRepositories(page: Int, limit: Int, forUser username: String, completion: @escaping NetworkManager.responseCallback){
        let url = URLs.repos.forUser(username, withParams: true).addQureyParam(key: "page", value: "\(page)", lastParam: false).addQureyParam(key: "per_page", value: "\(limit)", lastParam: true)
        guard ReachabilityUtility.shared.isReachable else {
            getDataFormDB(key: .Repos, model: Repositories.self, completion: completion)
            return
        }
        NetworkManager.shared.get(url: url) { [unowned self] (response) in
            self.handelResponseData(response: response, model: Repository.self, completion: completion)
        }
    }
}
