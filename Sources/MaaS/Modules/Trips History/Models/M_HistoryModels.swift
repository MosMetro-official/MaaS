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
    
    struct ViewModel {
        let viewState: M_TripsHistoryView.ViewState
    }
}
