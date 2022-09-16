//
//  M_ResScreenRouter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import OnBoardingModule

protocol M_ResScreenRoutingLogic: AnyObject {
    func routeToOnboarding()
    func popViewController()
    func routeToActive(with maskedPan: String)
    func showSupportController(_ supportController: UIViewController)
}

protocol M_ResScreenDataPassing: AnyObject {
    var dataStore: M_ResScreenDataStore? { get set }
}

final class M_ResScreenRouter: M_ResScreenRoutingLogic, M_ResScreenDataPassing {
  
    var dataStore: M_ResScreenDataStore?
    weak var controller: M_ResScreenController?
  
    init(controller: M_ResScreenController? = nil, dataStore: M_ResScreenDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func showSupportController(_ supportController: UIViewController) {
        controller?.present(supportController, animated: true)
    }
    
    func routeToActive(with maskedPan: String) {
        if maskedPan != "" {
            guard let activeController = controller?.navigationController?.viewControllers.first as? M_ActiveController else { return }
            activeController.router?.dataStore?.maskedPan = maskedPan
            controller?.navigationController?.popToRootViewController(animated: true)
        } else {
            let activeController = M_ActiveController()
            controller?.navigationController?.viewControllers[0] = activeController
            controller?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func routeToOnboarding() {
        UserDefaults.standard.set(true, forKey: "maasOnboarding")
        let board = OnBoardingModule()
        let boardController = board.getOnboarding(name: "onboarding_ios_maas")
        boardController.modalTransitionStyle = .crossDissolve
        boardController.modalPresentationStyle = .fullScreen
        controller?.present(boardController, animated: true)
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
