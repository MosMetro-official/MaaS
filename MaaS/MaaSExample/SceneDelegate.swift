//
//  SceneDelegate.swift
//  MaaSExample
//
//  Created by Слава Платонов on 13.05.2022.
//

import UIKit
import MaaS

class Dummy: MaaSNetworkDelegate {
    func refreshToken(completion: @escaping (Bool) -> Void) {
        completion(false)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let dummy = Dummy()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        MaaS.shared.networkDelegate = dummy
        let window = UIWindow(windowScene: windowScene)
        MaaS.shared.showMaaSFlow { startFlow in
            window.rootViewController = UINavigationController(rootViewController: startFlow)
        }
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let first = URLContexts.first?.url {
            print("🔥🔥🔥 URL FROM SCENEDELEGATE - \(first)")
            if first.absoluteString.contains(MaaS.RedirectUrls.succeedUrl.rawValue) {
                NotificationCenter.default.post(name: .maasPaymentSuccess,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.RedirectUrls.declinedUrl.rawValue) {
                NotificationCenter.default.post(name: .maasPaymentDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.RedirectUrls.canceledUrl.rawValue) {
                NotificationCenter.default.post(name: .maasPaymentCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.RedirectUrls.succeedUrlCard.rawValue) {
                NotificationCenter.default.post(name: .maasChangeCardSucceed,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.RedirectUrls.declinedUrlCard.rawValue) {
                NotificationCenter.default.post(name: .maasChangeCardDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.RedirectUrls.canceledUrlCard.rawValue) {
                NotificationCenter.default.post(name: .maasChangeCardCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
}
