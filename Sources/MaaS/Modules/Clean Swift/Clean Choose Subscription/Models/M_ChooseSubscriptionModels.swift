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
        
        let state: [State]
        let dataState: DataState
        let payButtonEnable: Bool
        let payButtonTitle: String
        let payCommand: Command<Void>?
        
        enum DataState {
            case loading(_Loading)
            case loaded
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
        
        struct SubSectionRow: _SubSectionRow {
            let id: String
            let title: String
            let price: String
            let isSelect: Bool
            let showSelectImage: Bool
            let tariffs: [M_Tariff]
            let onItemSelect: Command<Void>
            let height: CGFloat
        }
        
        static let initial = ViewModel(state: [], dataState: .loaded, payButtonEnable: false, payButtonTitle: "", payCommand: nil)
    }
}
