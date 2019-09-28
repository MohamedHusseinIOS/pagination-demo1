//
//  ViewModel.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation
import RxSwift
 
class HomeViewModel: BaseViewModel, ViewModelType {
    
    var input: HomeViewModel.Input
    var output: HomeViewModel.Output
    
    struct Input {}
    
    struct Output {
        let repositories: Observable<[Repository]>
        let faliure: Observable<[ErrorModel]>
    }
    
    private let faliure = PublishSubject<[ErrorModel]>()
    private let repositories = PublishSubject<[Repository]>()
    
    var reposetoryArray = [Repository]()
    
    override init() {
        input = Input()
        output = Output(repositories: repositories.asObservable(),
                        faliure: faliure.asObservable())
        super.init()
    }
    
    func getRepositories(pageNum: Int, limitPerPage: Int, forUser user: String) {
        DataManager.shared.getRepositories(page: pageNum, limit: limitPerPage, forUser: user, completion: {[unowned self] (response) in
            switch response {
            case .success(let value):
                //self.headerRefreshControl.endRefreshing()
                if let repositories = value as? [Repository] {
                    self.repositories.onNext(repositories)
                } else if let reposRes = value as? Repositories, let repos = reposRes.repositories {
                    self.repositories.onNext(repos)
                }
            case .failure( _, let data):
                self.handelError(data: data, failer: self.faliure)
            }
        })
    }
}
