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
            case loading
            case success(Action)
            case failure(Action)
        }
        
        struct Action {
            let title: String
            let descr: String
        }
        
        let hideAction: Bool?
        let dataState: DataState
        let logo: UIImage?
        let onAction: Command<Void>?
        let onClose: Command<Void>?
        
        static let initial = ViewState(hideAction: nil, dataState: .loading, logo: nil, onAction: nil, onClose: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingTitleLabel: UILabel!
    @IBOutlet private weak var loadingDescrLabel: UILabel!
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var resultTitleLabel: UILabel!
    @IBOutlet private weak var resultDescrLabel: UILabel!
    
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.titleLabel?.font = Appearance.getFont(.button)
        closeButton.titleLabel?.font = Appearance.getFont(.button)
    }
    
    @IBAction func actionButtonPressed() {
        viewState.onAction?.perform(with: ())
    }
    
    @IBAction func closeButtonPressed() {
        viewState.onClose?.perform(with: ())
    }
    
    private func prepareLoadingState() {
        [logoImageView,
         resultTitleLabel,
         resultDescrLabel,
         actionButton,
         closeButton].forEach { $0?.isHidden = true }
        
        [activityIndicator,
         loadingTitleLabel,
         loadingDescrLabel].forEach { $0?.isHidden = false }
    }
    
    private func prepareResultState() {
        [activityIndicator,
         loadingTitleLabel,
         loadingDescrLabel].forEach { $0?.isHidden = true }
        
        [logoImageView,
         resultTitleLabel,
         resultDescrLabel,
         actionButton,
         closeButton].forEach { $0?.isHidden = false }
    }
    
    private func render() {
        switch viewState.dataState {
        case .loading:
            prepareLoadingState()
        case .success(let success):
            resultTitleLabel.text = success.title
            resultDescrLabel.text = success.descr
            if let needHideAction = viewState.hideAction {
                actionButton.isHidden = needHideAction
            }
            prepareResultState()
            logoImageView.image = UIImage.getAssetImage(image: "checkmark")
        case .failure(let failure):
            resultTitleLabel.text = failure.title
            resultDescrLabel.text = failure.descr
            logoImageView.image = UIImage.getAssetImage(image: "error")
            prepareResultState()
        }
    }
}
