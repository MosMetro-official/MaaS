//
//  SceneDelegate.swift
//  MetroMaaS
//
//  Created by Слава Платонов on 25.04.2022.
//

import UIKit
import MaaS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MaaS.shared.showMaaSFlow()
        window?.makeKeyAndVisible()
    }
}

