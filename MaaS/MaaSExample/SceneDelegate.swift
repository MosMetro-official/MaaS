//
//  SceneDelegate.swift
//  MaaSExample
//
//  Created by Слава Платонов on 13.05.2022.
//

import UIKit
import MaaS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = MaaS.shared.showMaaSFlow()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
