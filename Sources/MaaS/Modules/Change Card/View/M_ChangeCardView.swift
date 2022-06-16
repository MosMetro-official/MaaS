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
        let cardType: String
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
        
        static let initial = ViewState(dataState: .loaded, cardType: "", cardNumber: "", countOfChangeCard: 0, onChangeButton: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    
    @IBOutlet weak var changeCardButton: UIButton!
    @IBOutlet weak var changeCardCountLabel: UILabel!
    @IBOutlet weak var countLabelBottomConstarint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
        setupLayers()
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
    
    private func setupLayers() {
        cardView.layer.cornerRadius = 10
        changeCardButton.layer.cornerRadius = 10
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            self.removeError(from: self)
            self.removeLoading(from: self)
            cardView.backgroundColor = UIColor.getCardHolderColor(for: viewState.cardType)
            cardImageView.image = UIImage.getCardHolderImage(for: viewState.cardType)
            cardNumberLabel.text = "•••• \(viewState.cardNumber)"
            changeCardCountLabel.text = viewState.countOfChangeCard == 0 ? "В этом месяце смена карты недоступна" : "Осталось смен карты в этом месяце – \(viewState.countOfChangeCard)"
            changeCardButton.isHidden = viewState.countOfChangeCard == 0
            if viewState.countOfChangeCard == 0 {
                countLabelBottomConstarint = nil
                changeCardCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -58).isActive = true
            }
        case .loading(let loading):
            self.removeError(from: self)
            self.showLoading(on: self, data: loading)
        case .error(let error):
            self.removeLoading(from: self)
            self.showError(on: self, data: error)
        }
        
    }
}
