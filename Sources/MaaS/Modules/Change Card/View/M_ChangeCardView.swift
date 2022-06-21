//
//  M_ChangeCardView.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView

class M_ChangeCardView: UIView {
    
    struct ViewState {
        
        enum DataState {
            case loading(_Loading)
            case loaded
            case error(_Error)
        }
        
        var dataState: DataState
        let cardType: PaySystem
        let cardNumber: String
        let countOfChangeCard: Int
        let onChangeButton: Command<Void>?
        
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
        
        static let initial = ViewState(dataState: .loaded, cardType: .unknown, cardNumber: "", countOfChangeCard: 0, onChangeButton: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descrLabel: UILabel!
    
    @IBOutlet private weak var changeCardButton: UIButton!
    @IBOutlet private weak var changeCardCountLabel: UILabel!
    @IBOutlet private weak var countLabelBottomConstarint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
    }
    
    @IBAction func onChangeButtonTapped() {
        viewState.onChangeButton?.perform(with: ())
    }
    
    private func setupLabels() {
        titleLabel.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
        descrLabel.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 1)
        titleLabel.textAlignment = .center
        descrLabel.textAlignment = .center
        changeCardButton.titleLabel?.font = Appearance.getFont(.button)
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            removeError(from: self)
            removeLoading(from: self)
            cardView.backgroundColor = UIColor.getCardHolderColor(for: viewState.cardType)
            cardImageView.image = UIImage.getCardHolderImage(for: viewState.cardType)
            cardNumberLabel.text = "•••• \(viewState.cardNumber)"
            changeCardCountLabel.text = viewState.countOfChangeCard == 0 ? "В этом месяце смена карты недоступна" : "Осталось смен карты в этом месяце – \(viewState.countOfChangeCard)"
            changeCardButton.isHidden = viewState.countOfChangeCard == 0
            if viewState.countOfChangeCard == 0 {
                countLabelBottomConstarint.constant = -changeCardButton.frame.height
            }
        case .loading(let loading):
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .error(let error):
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
