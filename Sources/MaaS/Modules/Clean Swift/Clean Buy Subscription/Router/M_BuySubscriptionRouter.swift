//
//  M_BuySubscriptionRouter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit

protocol M_BuySubscriptionRoutingLogic: AnyObject {
    func showPaymentController(_ paymentController: UIViewController)
    func routeToResultScreen(_ model: M_BuySubscriptionModels.Request.ResultModel)
    func popViewController()
}

protocol M_BuySubscriptionDataPassing: AnyObject {
    var dataStore: M_BuySubscriptionDataStore? { get set }
}

final class M_BuySubscriptionRouter: M_BuySubscriptionRoutingLogic, M_BuySubscriptionDataPassing {
  
    weak var controller: M_BuySubscriptionController?
    var dataStore: M_BuySubscriptionDataStore?
  
    init(controller: M_BuySubscriptionController? = nil, dataStore: M_BuySubscriptionDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func showPaymentController(_ paymentController: UIViewController) {
        DispatchQueue.main.async {
            self.controller?.present(paymentController, animated: true)
        }
    }
    
    func routeToResultScreen(_ model: M_BuySubscriptionModels.Request.ResultModel) {
        let resultController = M_ResScreenController()
        guard let sub = dataStore?.subscription else { return }
        switch model {
        case .success:
            resultController.router?.dataStore?.resultModel = .successSub(sub)
            controller?.navigationController?.pushViewController(resultController, animated: true)
        case .failure:
            resultController.router?.dataStore?.resultModel = .failureSub(id: sub.id)
            controller?.navigationController?.pushViewController(resultController, animated: true)
        }
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
