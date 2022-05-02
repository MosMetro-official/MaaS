//
//  M_ActiveSubView.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView

class M_ActiveSubView: UIView {

    @IBOutlet weak var titleLabel: GradientLabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var tableView: BaseTableView!

    struct ViewState {
        let timeLeft: String
        let state: [State]
        let dataState: DataState
        
        enum DataState {
            case loading
            case loaded
            case error
        }
        
        struct CardInfo: _CardInfo {
            let cardImage: UIImage
            let cardNumber: String
            let cardDescription: String 
        }
        
        struct HeaderCell: _HeaderTableCell { }
        
        struct TariffInfo: _TariffInfo {
            let transportTitle: String
            let tariffType: String?
            let totalTripCount: String?
            let leftTripCount: String?
            let showProgress: Bool
            let height: CGFloat
        }
        
        struct Onboarding: _Onboarding {
            let onOnboardingSelect: Command<Void>
            let onHistorySelect: Command<Void>
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        titleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        titleLabel.font = UIFont(name: "Comfortaa", size: 30)
        timeLeftLabel.font = UIFont(name: "MoscowSans-regular", size: 15)
    }
    
    private func render() {
        switch viewState.dataState {
        case .loading:
            print("loading")
        case .loaded:
            timeLeftLabel.text = viewState.timeLeft
            tableView.viewStateInput = viewState.state
        case .error:
            print("error")
        }
    }
    
}
