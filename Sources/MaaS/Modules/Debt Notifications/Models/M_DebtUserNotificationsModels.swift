//
//  M_DebtUserNotificationsModels.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import CoreTableView

enum M_DebtUserNotificationsModels {
    
    enum Request {
        
        struct Notification {
            let notification: M_MaasDebtNotifification
        }
    }
    
    enum Response {
        
        struct Notifications {
            let notifications: [M_MaasDebtNotifification]
        }
        
        struct Notification {
            let notification: M_MaasDebtNotifification
        }
        
        struct Loading {
            let title: String
            let descr: String
        }
        
        struct Error {
            let title: String
            let descr: String
            let notification: M_MaasDebtNotifification?
        }
    }
    
    struct ViewModel {
        let viewState: M_DebtNotificationsView.ViewState
    }
}
