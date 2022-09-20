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
    
    struct ViewModel {
        let viewState: M_ResultView.ViewState
    }
}
