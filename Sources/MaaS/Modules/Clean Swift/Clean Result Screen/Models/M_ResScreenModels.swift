//
//  M_ResScreenModels.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

enum M_ResScreenModels {
    
    enum Response {
        
        struct SupportForm {
            let urlString: String
        }
        
        struct ResultState {
            let res: ProcessType
            
            enum ProcessType {
                case sub(SubState)
                case card(CardState)
            }
            
            enum SubState {
                case success(M_Subscription)
                case failure(id: String)
            }
            
            enum CardState {
                case success(Card)
                case failure
                
                struct Card {
                    let maskedPan: String
                }
            }
        }
                
        struct Loading {
            let title: String
            let descr: String
        }
        
        struct Error {
            let title: String
            let descr: String
            let id: String
        }
    }
    
    enum ViewModel {
        
        struct ViewState {
            
            enum DataState {
                case none
                case success(Action)
                case failure(Action)
                case loading(_Loading)
                case error(_Error)
            }
            
            struct Action {
                let title: String
                let descr: String
            }
            
            struct Loading: _Loading {
                let title: String
                let descr: String
            }
            
            struct Error: _Error {
                let title: String
                let descr: String
                let onClose: Command<Void>
                let onRetry: Command<Void>
            }
            
            let dataState: DataState
            let logo: UIImage?
            let onAction: Command<Void>?
            let actionTitle: String
            let onClose: Command<Void>?
            var loadState: Bool = false
            var hideAction: Bool? = nil
            
            static let initial = ViewState(dataState: .none, logo: nil, onAction: nil, actionTitle: "", onClose: nil)
        }
    }
}
