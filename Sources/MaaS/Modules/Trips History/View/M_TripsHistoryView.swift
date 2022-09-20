//
//  M_TripsHistoryView.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

final class M_TripsHistoryView: UIView {
    
    struct ViewState {
        
        let state: [State]
        let dataState: DataState
        
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
            tableView.isHidden = false
            removeError(from: self)
            removeLoading(from: self)
            tableView.viewStateInput = viewState.state
        case .loading(let loading):
            tableView.isHidden = true
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .error(let error):
            tableView.isHidden = true
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
