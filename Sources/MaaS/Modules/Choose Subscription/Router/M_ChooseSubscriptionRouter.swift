//
//  M_ChooseSubscriptionRouter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import CoreAnalytics

protocol M_ChooseSubscriptionRoutingLogic: AnyObject {
    func dismiss()
    func routeToBuySubscription(analytics: _AnalyticsManager)
}

protocol M_ChooseSubscriptionDataPassing: AnyObject {
    var dataStore: M_ChooseSubscriptionDataStore? { get }
}

final class M_ChooseSubscriptionRouter: M_ChooseSubscriptionRoutingLogic, M_ChooseSubscriptionDataPassing {
    
    weak var controller: M_ChooseSubController?
    var dataStore: M_ChooseSubscriptionDataStore?
    
    init(controller: M_ChooseSubController? = nil, dataStore: M_ChooseSubscriptionDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func routeToBuySubscription(analytics: _AnalyticsManager) {
        let buySubscription = M_BuySubController(analyticsManager: analytics)
        guard
            let controller = controller,
            let dataStore = dataStore,
            let buySubDataStore = buySubscription.router?.dataStore else { return }
        buySubDataStore.subscription = dataStore.subscription
        controller.navigationController?.pushViewController(buySubscription, animated: true)
    }
    
    func dismiss() {
        controller?.dismiss(animated: true)
    }
}
