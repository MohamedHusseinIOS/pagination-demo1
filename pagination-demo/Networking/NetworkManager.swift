//
//  NetworkManager.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseEnum {
    case failure(_ error: ApiError?, _ data: Any?)
    case success(_ value: Any?)
}

enum ApiError: Int {
    case BadRequest = 400
    case DataValidationFailed = 422
    case ServerError = 500
    case ClientSideError = 0
    
    var message: String{
        switch self {
        case .BadRequest:
            return "Bad request"
        case .ServerError:
            return "Internal Server Error"
        case .ClientSideError:
            return "ClientSide Error"
        case .DataValidationFailed:
            return "Data Validation Failed"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init(){}
    typealias responseCallback = ((ResponseEnum) -> Void)
    
    private var headers: HTTPHeaders {
        let headerDict = ["":""]
        return headerDict
    }
    
    
    func get(url: String, paramters: Parameters? = nil, completion: @escaping responseCallback){
        
        Alamofire.request(url, method: .get, parameters: paramters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            response.interceptResuest(url, paramters)
            self.handleResponse(response, completion: completion)
        }
    }
    
    func post(url: String, paramters: Parameters?, completion: @escaping responseCallback){
        
        Alamofire.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            response.interceptResuest(url, paramters)
            DispatchQueue.main.async {
                 self.handleResponse(response, completion: completion)
            }
        }
    }
    
    private func handleResponse(_ response: DataResponse<Any>, completion: @escaping responseCallback) {
        guard let code = response.response?.statusCode else {
            completion(.failure(ApiError.ClientSideError, nil))
            return
        }
        if code < 400, let res = response.value as? Parameters {
            completion(.success(res))
        } else if code < 400, let res = response.value as? [Parameters] {
            completion(.success(res))
        } else if let res = response.value {
            self.errorHandling(res, code: code, completion: completion)
        }
    }
    
    func errorHandling(_ res: Any, code: Int,completion: @escaping responseCallback){
        let error = ApiError(rawValue: code)
        let errorModel = ErrorModel.decodeJSON(res, To: ErrorModel.self, format: .convertFromSnakeCase)
        completion(.failure(error, errorModel))
    }
}
