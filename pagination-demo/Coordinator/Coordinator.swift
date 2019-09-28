//
//  Coordinator.swift
//  pagination-demo
//
//  Created by Mohamed Hussien on 28/09/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    static let shared = Coordinator()
    
    private var nvc: UINavigationController!
    private var childNVC: UINavigationController!
    
    private var window: UIWindow?
    
    private var mainNavigator: MainNavigator!
    var childNavigator: MainNavigator?
    var parentViewController: BaseViewController?
    
    private init(nvc: UINavigationController = UINavigationController()) {
        self.nvc = nvc
        self.mainNavigator = MainNavigator(navigationController: self.nvc)
    }
    
    func addChildNVC(_ childNVC: UINavigationController, parentViewController: BaseViewController) {
        self.parentViewController = parentViewController
        self.childNVC = childNVC
        childNavigator = MainNavigator(navigationController: self.childNVC)
    }
    
    func startApp( window: UIWindow?) {
        mainNavigator.navigate(To: .homeViewController)
        nvc.setNavigationBarHidden(true, animated: false)
        self.window = window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
}
