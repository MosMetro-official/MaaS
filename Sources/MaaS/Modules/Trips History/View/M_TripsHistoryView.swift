//
//  M_TripsHistoryView.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

class M_TripsHistoryView: UIView {
    
    @IBOutlet weak var tableView: BaseTableView!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            self.removeError(from: self)
            self.removeLoading(from: self)
            self.tableView.viewStateInput = viewState.state
        case .loading(let loading):
            self.removeError(from: self)
            self.showLoading(on: self, data: loading)
        case .error(let error):
            self.removeLoading(from: self)
            self.showError(on: self, data: error)
        }
    }
    
    
}
