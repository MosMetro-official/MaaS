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
    
    struct ViewModel {
        let viewState: M_ChangeCardView.ViewState
    }
}
