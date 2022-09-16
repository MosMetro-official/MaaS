//
//  M_ModalDebtNotificationView.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView

public class M_ModalDebtNotificationView: UIView {
    
    struct ViewState {
        
        enum DataState {
            case loading(_Loading)
            case error(_Error)
            case loaded
        }
        
        let dataState: DataState
        let onMore: Command<Void>
        let debtText: String
        let titleText: String
        let buttonTitle: String
        
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
        
        static let initial = ViewState(dataState: .loaded, onMore: Command {}, debtText: "", titleText: "", buttonTitle: "")
    }
    
    var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descrLabel: UILabel!
    @IBOutlet private var moreButton: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func onMoreTapped() {
        viewState.onMore.perform(with: ())
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            titleLabel.text = viewState.titleText
            descrLabel.text = viewState.debtText
            moreButton.setTitle(viewState.buttonTitle, for: .normal)
            removeError(from: self)
            removeLoading(from: self)
        case .loading(let loading):
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .error(let error):
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
