//
//  M_ActiveSubModels.swift
//  MaaS
//
//  Created by Слава Платонов on 01.08.2022.
//

import CoreTableView

enum M_ActiveSubModels {
    
    enum Response {
        
        struct UserInfo {
            var user: M_UserInfo?
            var debtNotifications: [M_MaasDebtNotifification]?
            var notification: M_MaasDebtNotifification?
            var newMaskedPan: String?
            var oldMaskedPan: String?
            
            var needReloadCard: Bool {
                newMaskedPan == oldMaskedPan
            }
            
            var sortedNotifications: [M_MaasDebtNotifification] {
                guard let notifications = debtNotifications else { return [] }
                let sorted = notifications.sorted {
                    guard $0.date != nil, $1.date != nil else { return false }
                    return $0.date! > $1.date!
                }
                return sorted
            }
            
            mutating func findUnreadMessages() -> Bool {
                let unReadMessage = sortedNotifications.first { $0.read == false }
                self.notification = unReadMessage
                return unReadMessage != nil
            }
        }
        
        struct Debt {
            let notification: M_MaasDebtNotifification
        }
        
        struct Loading {
            let title: String
            let descr: String
        }
        
        struct Error {
            let title: String
            let descr: String
            let isCardError: Bool
        }
        
        struct SupportForm {
            let url: String
        }
    }
    
    enum ViewModel {
        
        struct SupportForm {
            let url: String
        }
        
        struct ViewState {
            
            enum DataState {
                case loaded([State])
                case loading(Loading)
                case error(Error)
            }
            
            struct Error: _Error {
                let title: String
                let descr: String
                let onRetry: Command<Void>
                let onClose: Command<Void>
            }
            
            struct Loading: _Loading {
                let title: String
                let descr: String
            }
        }
    }
}
