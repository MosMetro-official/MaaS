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
    
    enum ViewModel {
        
        struct ViewState {
            
            let state: [State]
            let dataState: DataState
            let linkCardCommand: Command<Void>?
            
            enum DataState {
                case loaded
                case loading(_Loading)
                case error(_Error)
            }
            
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
            
            struct SubHeader: _SubHeader {
                var id: String
                let title: String
                let price: String
                let height: CGFloat
            }
            
            struct DescrRow: _DescriptionCell {
                var id: String
                let title: String
                let descr: String
                let imageUrl: String
                let height: CGFloat
            }
            
            static let initial = ViewState(state: [], dataState: .loaded, linkCardCommand: Command(action: {}))
        }
    }
}
