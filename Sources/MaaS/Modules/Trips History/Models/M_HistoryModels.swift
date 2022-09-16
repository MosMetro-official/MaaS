//
//  M_HistoryModels.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import CoreTableView

enum M_HistoryModels {
    
    enum Request {
        
        struct Trips {
            let isLoadingMore: Bool
        }
        
        struct Error {
            let title: String
            let descr: String
        }
        
    }
    
    enum Response {
        struct Trips {
            let trips: [M_HistoryTrips]
            let isLoadingMore: Bool
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
            
            struct History: _History {
                let id: String
                let title: String
                var imageURL: URL?
                let date: String
                let route: String
                let height: CGFloat
            }
            
            struct LoadMore: M_LoadMoreCell {
                var state: M_LoadMoreTableViewCell.State
                var onLoad: Command<Void>
            }
            
            struct Empty: _Empty {
                let id: String
                let height: CGFloat
            }
            
            static let initial = ViewState(state: [], dataState: .loaded)
        }
    }
}
