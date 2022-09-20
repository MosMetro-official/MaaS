//
//  M_ChangeCardView.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView

final class M_ChangeCardView: UIView {
    
    struct ViewState {
        
        let dataState: DataState
        let cardType: PaySystem
        let cardNumber: String
        let countOfChangeCard: Int
        let onChangeButton: Command<Void>?
        
        enum DataState {
            case loading(_Loading)
            case loaded
            case error(_Error)
        }
        
        struct Error: _Error {
            let title: String
            let descr: String
            let onRetry: Command<Void>
            let onClose: Command<Void>
        }
        
        struct Loading: _Loading {
            let title: String
            let descr: String
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
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            [cardView, cardImageView, cardNumberLabel, titleLabel, descrLabel, changeCardCountLabel].forEach { $0?.isHidden = false }
            removeError(from: self)
            removeLoading(from: self)
            cardView.backgroundColor = UIColor.getCardHolderColor(for: viewState.cardType)
            cardImageView.image = UIImage.getCardHolderImage(for: viewState.cardType)
            cardNumberLabel.text = "•••• \(viewState.cardNumber)"
            changeCardCountLabel.text = viewState.countOfChangeCard == 0 ? "Смена карты недоступна" : "Осталось смен карты – \(viewState.countOfChangeCard)"
            changeCardButton.isHidden = viewState.countOfChangeCard == 0
            if viewState.countOfChangeCard == 0 {
                countLabelBottomConstarint.constant = -changeCardButton.frame.height
            }
        case .error(let error):
            [cardView, cardImageView, cardNumberLabel, titleLabel, descrLabel, changeCardButton, changeCardCountLabel].forEach { $0?.isHidden = true }
            removeLoading(from: self)
            showError(on: self, data: error)
        case .loading(let loading):
            [cardView, cardImageView, cardNumberLabel, titleLabel, descrLabel, changeCardButton, changeCardCountLabel].forEach { $0?.isHidden = true }
            removeError(from: self)
            showLoading(on: self, data: loading)
        }
    }
}
