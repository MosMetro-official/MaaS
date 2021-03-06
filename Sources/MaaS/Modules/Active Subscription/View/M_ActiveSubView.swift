//
//  M_ActiveSubView.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView

class M_ActiveSubView: UIView {

    struct ViewState {
        let state: [State]
        let dataState: DataState
        
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
        
        struct StatusInfo: _StatusInfoCell {
            let title: String
            let descr: String
            let imageStatus: UIImage
            let onAction: Command<Void>?
            let actionTitle: String
            let height: CGFloat
        }
        
        struct DebtInfo: _DebtInfoCell {
            let totalDebt: String
            let onButton: Command<Void>
            let height: CGFloat
        }
        
        struct TitleHeader: _TitleHeader {
            let title: String
            let timeLeft: String
            let height: CGFloat
        }
        
        struct CardInfo: _CardInfo {
            let cardImage: PaySystem
            let cardNumber: String
            let cardDescription: String
            let leftCountChangeCard: String
            let isUpdate: Bool
            let onItemSelect: Command<Void>
            let height: CGFloat
        }
        
        struct HeaderCell: _HeaderTableCell {
            let height: CGFloat
        }
        
        struct TariffInfo: _TariffInfo {
            let transportTitle: String
            let tariffType: String
            let showProgress: Bool
            let currentProgress: CGFloat?
            let height: CGFloat
        }
        
        struct Onboarding: _Onboarding {
            let onOnboardingSelect: Command<Void>
            let onHistorySelect: Command<Void>
        }
        
        struct Support: _SupportCell {
            let onItemSelect: Command<Void>
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
    }
    
    private func render() {
        switch viewState.dataState {
        case .loading(let loading):
            tableView.isHidden = true
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .loaded:
            tableView.isHidden = false
            removeLoading(from: self)
            removeError(from: self)
            tableView.viewStateInput = viewState.state
        case .error(let error):
            tableView.isHidden = false
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
