//
//  M_BuySubscriptionModels.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

enum M_BuySubscriptionModels {
    
    enum Request {
        
        struct Loading {
            let title: String
        }
        
        enum ResultModel {
            case success
            case failure
        }
    }
    
    enum Response {
        
        struct Subscription {
            let sub: M_Subscription
        }
        
        struct PaymentPath {
            let path: String
        }
        
        struct Error {
            let title: String
            let descr: String
        }
        
        struct Loading {
            let title: String
            let descr: String
        }
    }
    
    struct ViewModel {
        let viewState: M_BuySubView.ViewState
    }
}
