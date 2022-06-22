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
        guard let _ = (scene as? UIWindowScene) else { return }
        MaaS.shared.networkDelegate = dummy
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let first = URLContexts.first?.url {
            print("🔥🔥🔥 URL FROM SCENEDELEGATE - \(first)")
            if first.absoluteString.contains(MaaS.shared.succeedUrl) {
                NotificationCenter.default.post(name: .maasPaymentSuccess,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.shared.declinedUrl) {
                NotificationCenter.default.post(name: .maasPaymentDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.shared.canceledUrl) {
                NotificationCenter.default.post(name: .maasPaymentCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.shared.succeedUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardSucceed,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.shared.declinedUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.shared.canceledUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
}
