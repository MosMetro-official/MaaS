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
        let timeLeft: String
        let state: [State]
        let dataState: DataState
        
        enum DataState {
            case loading
            case loaded
            case error
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
            let cardImage: UIImage
            let cardNumber: String
            let cardDescription: String
            let leftCountChangeCard: String
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
        
        static let initial = ViewState(timeLeft: "", state: [], dataState: .loading)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
    @IBOutlet weak var tableView: BaseTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    private func render() {
        switch viewState.dataState {
        case .loading:
            print("loading")
        case .loaded:
            tableView.viewStateInput = viewState.state
        case .error:
            print("error")
        }
    }
    
}
