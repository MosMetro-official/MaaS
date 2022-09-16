//
//  M_HistoryRouter.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import UIKit

protocol M_HistoryRoutingLogic: AnyObject {
    func popViewController()
}

final class M_HistoryRouter: M_HistoryRoutingLogic {
  
    weak var controller: M_HistoryController?
  
    init(controller: M_HistoryController? = nil) {
        self.controller = controller
    }
    
    func popViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
