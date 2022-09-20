//
//  M_ChooseSubscriptionModels.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

enum M_ChooseSubscriptionModels {
    
    enum Response {
        struct Subscription {
            let subs: [M_Subscription]
            let selectedSub: M_Subscription?
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
        let viewState: M_ChooseSubView.ViewState
    }
}
