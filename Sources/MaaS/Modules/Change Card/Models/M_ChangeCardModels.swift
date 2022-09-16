//
//  M_ChangeCardModels.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import CoreTableView

enum M_CardChangeModels {
    
    enum Request {
        
        struct Loading {
            let title: String
            let descr: String
        }
        
        enum ResultModel {
            case success
            case failure
        }
    }
    
    enum Response {
        
        struct ChangeCardUrl {
            let urlPath: String
        }
        
        struct UserInfo {
            let user: M_UserInfo
        }
        
        struct Loading {
            let title: String
            let descr: String
        }
        
        struct Error {
            let title: String
            let descr: String
        }
    }
    
    enum ViewModel {
        
        struct ViewState {
            
            enum DataState {
                case loading(_Loading)
                case loaded
                case error(_Error)
            }
            
            let dataState: DataState
            let cardType: PaySystem
            let cardNumber: String
            let countOfChangeCard: Int
            let onChangeButton: Command<Void>?
            
            static let initial = ViewState(dataState: .loaded, cardType: .unknown, cardNumber: "", countOfChangeCard: 0, onChangeButton: nil)
            
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
