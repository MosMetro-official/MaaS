//
//  M_ResultView.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView

class M_ResultView: UIView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingTitleLabel: UILabel!
    @IBOutlet weak var loadingDescrLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultDescrLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.titleLabel?.font = Appearance.getFont(.button)
        closeButton.titleLabel?.font = Appearance.getFont(.button)
        actionButton.layer.cornerRadius = 10
        closeButton.layer.cornerRadius = 10
    }
    
    @IBAction func actionButtonPressed() {
        
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
