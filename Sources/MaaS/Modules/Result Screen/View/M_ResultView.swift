//
//  M_ResultView.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView

class M_ResultView: UIView {
    
    struct ViewState {
                
        enum DataState {
            case none
            case success(Action)
            case failure(Action)
            case loading(_Loading)
            case error(_Error)
        }
        
        struct Action {
            let title: String
            let descr: String
        }
        
        struct Loading: _Loading {
            let title: String
            let descr: String
        }
        
        struct Error: _Error {
            let title: String
            let descr: String
            let onClose: Command<Void>
            let onRetry: Command<Void>
        }
        
        let dataState: DataState
        let logo: UIImage?
        let onAction: Command<Void>?
        let actionTitle: String
        let onClose: Command<Void>?
        var loadState: Bool = false
        var hideAction: Bool? = nil
        
        static let initial = ViewState(dataState: .none, logo: nil, onAction: nil, actionTitle: "", onClose: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var resultTitleLabel: UILabel!
    @IBOutlet private weak var resultDescrLabel: UILabel!
    
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionButtonPressed() {
        viewState.onAction?.perform(with: ())
    }
    
    @IBAction func closeButtonPressed() {
        viewState.onClose?.perform(with: ())
    }
    
    private func setVision(is loading: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            [self.logoImageView, self.resultTitleLabel, self.resultDescrLabel, self.actionButton, self.closeButton].forEach { $0?.isHidden = loading }
        }
        animator.startAnimation()
    }
    
    private func render() {
        switch viewState.dataState {
        case .none:
            break
        case .success(let success):
            removeError(from: self)
            removeLoading(from: self)
            resultTitleLabel.text = success.title
            resultDescrLabel.text = success.descr
            if let needAction = viewState.hideAction {
                actionButton.isHidden = needAction
            }
            actionButton.setTitle(viewState.actionTitle, for: .normal)
            logoImageView.image = UIImage.getAssetImage(image: "checkmark")
            setVision(is: viewState.loadState)
        case .failure(let failure):
            resultTitleLabel.text = failure.title
            resultDescrLabel.text = failure.descr
            logoImageView.image = UIImage.getAssetImage(image: "error")
            actionButton.setTitle(viewState.actionTitle, for: .normal)
            setVision(is: viewState.loadState)
        case.loading(let data):
            setVision(is: viewState.loadState)
            removeError(from: self)
            showLoading(on: self, data: data)
        case .error(let data):
            setVision(is: viewState.loadState)
            removeLoading(from: self)
            showError(on: self, data: data)
        }
    }
}
