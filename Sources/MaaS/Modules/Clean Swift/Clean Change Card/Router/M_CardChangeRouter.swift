//
//  M_CardChangeRouter.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import UIKit

protocol CardChangeRoutingLogic: AnyObject {
    func popViewController()
    func presentSafariController(_ controller: UIViewController)
    func routeToResultScreen(_ model: M_CardChangeModels.Request.ResultModel)
}

protocol CardChangeDataPassing: AnyObject {
    var dataStore: CardChangeDataStore? { get set }
}

final class M_CardChangeRouter: CardChangeRoutingLogic, CardChangeDataPassing {
    
    weak var controller: M_CardChangeController?
    var dataStore: CardChangeDataStore?
    
    init(controller: M_CardChangeController? = nil, dataStore: CardChangeDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func presentSafariController(_ safariController: UIViewController) {
        controller?.present(safariController, animated: true)
    }
    
    func routeToResultScreen(_ model: M_CardChangeModels.Request.ResultModel) {
        let resultController = M_ResScreenController()
        guard let userInfo = dataStore?.userInfo else { return }
        switch model {
        case .success:
            resultController.router?.dataStore?.resultModel = .successCard(userInfo)
            controller?.navigationController?.pushViewController(resultController, animated: true)
        case .failure:
            resultController.router?.dataStore?.resultModel = .failureCard
            controller?.navigationController?.pushViewController(resultController, animated: true)
        }
    }
    
    deinit {
        print("🥰🥰🥰 CardChangeRouter deinited")
    }
}
