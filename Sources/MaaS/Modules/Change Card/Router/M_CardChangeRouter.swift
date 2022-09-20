//
//  M_CardChangeRouter.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import UIKit
import CoreAnalytics

protocol CardChangeRoutingLogic: AnyObject {
    func popViewController()
    func presentSafariController(_ controller: UIViewController)
    func routeToResultScreen(_ model: M_CardChangeModels.Request.ResultModel, analyticsManager: _AnalyticsManager)
}

protocol CardChangeDataPassing: AnyObject {
    var dataStore: M_CardChangeDataStore? { get set }
}

final class M_CardChangeRouter: CardChangeRoutingLogic, CardChangeDataPassing {
    
    weak var controller: M_ChangeCardController?
    var dataStore: M_CardChangeDataStore?
    
    init(controller: M_ChangeCardController? = nil, dataStore: M_CardChangeDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func presentSafariController(_ safariController: UIViewController) {
        controller?.present(safariController, animated: true)
    }
    
    func routeToResultScreen(_ model: M_CardChangeModels.Request.ResultModel, analyticsManager: _AnalyticsManager) {
        let resultController = M_ResultController(analyticsManager: analyticsManager)
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
