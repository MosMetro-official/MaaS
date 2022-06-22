//
//  M_TripsHistoryView.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

class M_TripsHistoryView: UIView {
        
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
            let title: String
            let image: UIImage
            let date: String
            let height: CGFloat
        }
        
        struct Empty: _Empty {
            let height: CGFloat
        }
        
        static let initial = ViewState(state: [], dataState: .loaded)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            removeError(from: self)
            removeLoading(from: self)
            tableView.viewStateInput = viewState.state
        case .loading(let loading):
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .error(let error):
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
