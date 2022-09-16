//
//  M_DebtNotificationsView.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView

public class M_DebtNotificationsView: UIView {
    
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
        
        struct Header: _HeaderNotification {
            var id: String
            
            let height: CGFloat
        }
        
        struct Notification: _Notification {
            var id: String
            
            let title: String
            let descr: String
            let onItemSelect: Command<Void>
            let height: CGFloat
        }
        
        static let initial = ViewState(state: [], dataState: .loaded)
    }
    
    var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
//                self.render()
            }
        }
    }
    
    var viewModel: M_DebtUserNotificationsModels.ViewModel.ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.renderViewModel()
            }
        }
    }
    
    @IBOutlet private var tableView: BaseTableView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        tableView.shouldUseReload = true
    }
    
    private func renderViewModel() {
        switch viewState.dataState {
        case .loaded:
            removeError(from: self)
            removeLoading(from: self)
            tableView.isHidden = false
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
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            removeError(from: self)
            removeLoading(from: self)
            tableView.isHidden = false
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
