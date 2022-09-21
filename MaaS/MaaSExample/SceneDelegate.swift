//
//  SceneDelegate.swift
//  MaaSExample
//
//  Created by Слава Платонов on 13.05.2022.
//

import UIKit
import MaaS

class Dummy: MaaSNetworkDelegate {
    func refreshToken() async throws {
        debugPrint("-_- 401 -_-")
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let dummy = Dummy()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        MaaS.networkDelegate = dummy
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let first = URLContexts.first?.url {
            print("🔥🔥🔥 URL FROM SCENEDELEGATE - \(first)")
            if first.absoluteString.contains(MaaS.succeedUrl) {
                NotificationCenter.default.post(name: .maasPaymentSuccess,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.declinedUrl) {
                NotificationCenter.default.post(name: .maasPaymentDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.canceledUrl) {
                NotificationCenter.default.post(name: .maasPaymentCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.succeedUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardSucceed,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.declinedUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardDeclined,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.canceledUrlCard) {
                NotificationCenter.default.post(name: .maasChangeCardCanceled,
                                                object: nil,
                                                userInfo: nil)
            }
            
            if first.absoluteString.contains(MaaS.supportForm) {
                NotificationCenter.default.post(name: .maasSupportForm,
                                                object: nil,
                                                userInfo: nil)
            }
        }
    }
}
