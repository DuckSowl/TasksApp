//
//  SceneDelegate.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var showDetail = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        showDetail = true
        let navigationController = window?.rootViewController as? UINavigationController
        let tasksVC = navigationController!.viewControllers[0] as! TasksViewController
        navigationController?.popToViewController(tasksVC,
                                                  animated: true)
        tasksVC.showNearestTask()
    }
}

