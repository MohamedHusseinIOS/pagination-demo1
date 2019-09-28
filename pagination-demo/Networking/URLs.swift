//
//  URLs.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation

enum URLs: String {
    case repos = "/repos"
    
    private var url: String {
        return "https://api.github.com/"
    }
    
    private var users: String {
        return url + "users/"
    }
    
    func forUser(_ user: String, withParams: Bool) -> String {
        let userUrl = users + user + rawValue
        return withParams ? userUrl + "?" : userUrl
    }
    
}
