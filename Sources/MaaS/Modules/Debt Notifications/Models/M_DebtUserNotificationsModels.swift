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
    
    enum ViewModel {
        
        struct ViewState {
            
            enum DataState {
                case loaded
                case loading(_Loading)
                case error(_Error)
            }
            
            let state: [State]
            let dataState: DataState
            
            struct Loading: _Loading {
                let title: String
                let descr: String
            }
            
            struct Error: _Error {
                let title: String
                let descr: String
                let onRetry: Command<Void>
                let onClose: Command<Void>
            }
            
            struct Header: _HeaderNotification {
                var id: String
                
                let height: CGFloat
            }
            
            struct Notification: _Notification {
                var id: String
                
                let title: String
                let descr: String
                let onItemSelect: Command<Void>
                let height: CGFloat
            }
            
            static let initial = ViewState(state: [], dataState: .loaded)
        }
    }
}
