//
//  M_DebtUserNotificationsRouter.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import UIKit

protocol M_DebtUserNotificationsRoutingLogic: AnyObject {
    func popViewController()
    func presentSafariController(_ safariController: UIViewController)
}

protocol M_DebtUserNotificationsDataPassing: AnyObject {
    var dataStore: M_DebtUserNotificationDataStore? { get set }
}

final class M_DebtUserNotificationsRouter: M_DebtUserNotificationsRoutingLogic, M_DebtUserNotificationsDataPassing {
  
    weak var controller: M_DebtUserNotificationsController?
    var dataStore: M_DebtUserNotificationDataStore?
  
    init(controller: M_DebtUserNotificationsController? = nil, dataStore: M_DebtUserNotificationDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func presentSafariController(_ safariController: UIViewController) {
        DispatchQueue.main.async {
            self.controller?.present(safariController, animated: true)
        }
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
